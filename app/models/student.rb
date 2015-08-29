class Student < ActiveRecord::Base
  only_digits :phone

  belongs_to :classroom

  enum gender: [:male, :female]
  enum status: [:normal, :locked]

  validates :name, :gender, :birth_date, :classroom, presence: true
  validates :birth_date, date: { before_than: Proc.new { Date.current } }
  validates :cpf, cpf: true, uniqueness: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :gender, inclusion: { in: Student.genders.keys }
  validates :status, inclusion: { in: Student.statuses.keys }

  scope :filter, -> (text) {
    if text.present?
      cleaned_text = text.gsub(/[\-|\s|\.|\(|\)]/, '')

      joins(:classroom)
      .where('name ILIKE :text OR email ILIKE :text OR cpf ILIKE :special OR phone ILIKE :special',
        text: "%#{text}%", special: "%#{cleaned_text}%")
    end
  }

  scope :in_classroom, -> (classroom) {
    classroom = classroom.try(:id) || classroom
    if classroom.present?
      joins(:classroom)
      .where{classrooms.id == classroom}
    end
  }

  def formatted_phone
    cleaned_phone = self.phone.to_s.gsub(/\D/, '')
    Phonie.configure { |c| c.n1_length = (cleaned_phone.size > 10) ? 5 : 4 }
    Phonie::Phone.parse(cleaned_phone).try(:format, :br)
  end

  def formatted_cpf
    Cpf.new(self.cpf).to_s
  end

  def lock
    self.update status: :locked if self.normal?
  end

  def unlock
    self.update status: :normal unless self.normal?
  end
end
