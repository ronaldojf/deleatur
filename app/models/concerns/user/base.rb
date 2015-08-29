module User::Base
  extend ActiveSupport::Concern

  included do
    def user_type
      self.class.name.underscore.to_sym
    end

    [:administrator, :teacher, :student].each do |key|
      define_method("#{key}?".to_sym) do
        self.user_type == key
      end
    end
  end
end