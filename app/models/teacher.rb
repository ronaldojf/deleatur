class Teacher < ActiveRecord::Base
  only_digits :phone

  enum gender: [:male, :female]
  enum status: [:pending, :approved, :locked]

  validates :name, :gender, :cpf, :phone, :birth_date, presence: true
  validates :birth_date, date: { before_than: Proc.new { Date.current } }
  validates :cpf, cpf: true
  validates :phone, phone: true
  validates :gender, inclusion: { in: Teacher.genders.keys }
  validates :status, inclusion: { in: Teacher.statuses.keys }

  scope :filter, -> (text) {
    if text.present?
      where('name ILIKE :text OR email ILIKE :text OR cpf ILIKE :special OR phone ILIKE :special',
        text: "%#{text}%", special: "%#{text.gsub(/[\-|\s|\.|\(|\)]/, '')}%")
    end
  }

  def formatted_phone
    Phonie.configure { |c| c.n1_length = (self.phone.size > 10) ? 5 : 4 }
    Phonie::Phone.parse(self.phone).format(I18n.locale)
  end

  def formatted_cpf
    Cpf.new(self.cpf).to_s
  end

  def lock
    self.update status: :locked if self.approved?
  end

  def approve
    self.update status: :approved unless self.approved?
  end

  def disapprove
    self.destroy if self.pending?
  end
end
