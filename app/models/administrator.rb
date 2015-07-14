class Administrator < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable, :confirmable

  validates :name, presence: true

  scope :filter, -> (text) {
    where('name ILIKE :text OR email ILIKE :text')
  }

  def destroy
    self.main? ? false : super
  end
end
