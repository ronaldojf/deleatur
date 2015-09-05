class Administrator < ActiveRecord::Base
  include User::Base, Utils::Filtering
  devise :database_authenticatable, :recoverable, :validatable

  attr_accessor :current_password, :validate_current_password

  validates :name, presence: true
  validate :authenticate_password, if: :validate_current_password

  filtering :name, :email

  def destroy
    self.main? ? false : super
  end
end
