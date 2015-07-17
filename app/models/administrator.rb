class Administrator < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  validates :name, presence: true

  scope :filter, -> (text) {
    where('name ILIKE :text OR email ILIKE :text', text: "%#{text}%") if text.present?
  }

  def destroy
    self.main? ? false : super
  end

  def update(params)
    self.main? ? false : super(params)
  end
end
