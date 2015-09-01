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

  private

  def authenticate_password
    if self.password.present? && !Administrator.find(self.id).valid_password?(@current_password.to_s)
      errors.add(:current_password, I18n.t('errors.custom_messages.current_password_not_match'))
    end
  end
end
