class Student < ActiveRecord::Base
  include User::Base, Person::Base, Utils::AttributesCleaner, Utils::Filtering
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :confirmable
  only_digits :phone

  belongs_to :classroom
  has_many :teachers, through: :classroom
  has_many :answered_questionnaires

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
