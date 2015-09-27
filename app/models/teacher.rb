class Teacher < ActiveRecord::Base
  include User::Base, Person::Base, Utils::AttributesCleaner, Utils::Filtering
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :confirmable
  only_digits :phone

  has_many :classrooms_subjects, class_name: 'TeacherClassroomSubject', dependent: :destroy
  has_many :classrooms, -> { uniq }, through: :classrooms_subjects, source: :classroom
  has_many :subjects, -> { uniq }, through: :classrooms_subjects, source: :subject
  accepts_nested_attributes_for :classrooms_subjects, allow_destroy: true

  enum gender: [:male, :female]
  enum status: [:pending, :approved, :locked]

  validates :name, :gender, :cpf, :phone, :birth_date, presence: true
  validates :birth_date, date: { before: Proc.new { Date.current } }
  validates :cpf, cpf: true, uniqueness: true
  validates :phone, phone: true
  validates :gender, inclusion: { in: Teacher.genders.keys }
  validates :status, inclusion: { in: Teacher.statuses.keys }

  filtering :name, :email, simple_clear: [:cpf, :phone]

  def lock
    self.update status: :locked if self.approved?
  end

  def approve
    self.update status: :approved unless self.approved?
  end

  def disapprove
    self.destroy if self.pending?
  end

  def active_for_authentication?
    super && self.approved?
  end
end
