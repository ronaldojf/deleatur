module User::Base
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_password, :validate_current_password

    validate :authenticate_password, if: :validate_current_password

    def user_type
      self.class.name.underscore.to_sym
    end

    [:administrator, :teacher, :student].each do |key|
      define_method("#{key}?".to_sym) do
        self.user_type == key
      end
    end

    private

    def authenticate_password
      if self.password.present? && !Administrator.find(self.id).valid_password?(@current_password.to_s)
        errors.add(:current_password, I18n.t('errors.custom_messages.current_password_not_match'))
      end
    end
  end
end