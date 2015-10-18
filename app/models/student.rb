class Student < ActiveRecord::Base
  include User::Base, Person::Base, Utils::AttributesCleaner, Utils::Filtering
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :confirmable
  only_digits :phone

  belongs_to :classroom
  has_many :pontuations, dependent: :destroy
  has_many :teachers, through: :classroom
  has_many :answered_questionnaires, dependent: :destroy
  has_many :questionnaires, -> { published }, through: :classroom

  enum gender: [:male, :female]
  enum status: [:normal, :locked]

  validates :name, :gender, :birth_date, :classroom, presence: true
  validates :birth_date, date: { before: Proc.new { Date.current } }
  validates :cpf, cpf: true, uniqueness: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :gender, inclusion: { in: Student.genders.keys }
  validates :status, inclusion: { in: Student.statuses.keys }

  filtering :name, :email, simple_clear: [:cpf, :phone]

  scope :in_classroom, -> (classroom) {
    classroom = classroom.try(:id) || classroom
    if classroom.present?
      joins(:classroom)
      .where{classrooms.id == classroom}
    end
  }

  scope :top_ranking, -> (limit) {
    Student
      .joins(:classroom)
      .joins{pontuations.outer}
      .select('students.*, classrooms.identifier AS classroom_identifier,
                SUM(COALESCE(pontuations.points, 0)) AS total_points')
      .where(status: statuses[:normal])
      .order('total_points DESC')
      .limit(limit.to_i)
      .group(:id, 'classroom_identifier')
  }

  scope :ranking_with_position, -> {
    Student
      .joins(:classroom)
      .joins{pontuations.outer}
      .select('students.id, students.classroom_id, classrooms.identifier AS classroom_identifier,
              SUM(COALESCE(pontuations.points, 0)) AS total_points,
              (ROW_NUMBER() OVER (ORDER BY SUM(COALESCE(pontuations.points, 0)) DESC)) AS ranking_position')
      .where(status: statuses[:normal])
      .group(:id, 'classroom_identifier')
  }

  def student_questionnaires
    self.questionnaires
      .select([:id, :title, :subject_id, :teacher_id, :updated_at,
          'COALESCE(answered_questionnaires.status, 0) AS status',
          'COALESCE(pontuations.points, 0) AS points'])
      .joins("LEFT JOIN answered_questionnaires
                ON (questionnaires.id = answered_questionnaires.questionnaire_id AND
                    answered_questionnaires.student_id = #{self.id})")
      .joins("LEFT JOIN pontuations ON (answered_questionnaires.id = pontuations.answered_questionnaire_id)")
  end

  def get_ranking
    Student
      .select([:total_points, :ranking_position, :classroom_identifier])
      .from("(#{Student.ranking_with_position.to_sql}) AS students")
      .joins(:classroom)
      .where(id: self.id)
      .first
  end

  def lock
    self.update status: :locked if self.normal?
  end

  def unlock
    self.update status: :normal unless self.normal?
  end

  def active_for_authentication?
    super && !self.locked?
  end
end
