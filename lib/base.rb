module ActiveRecord
  class Base
    def self.only_digits(*fields)
      fields = [fields] unless fields.is_a?(Array)
      fields.each do |field|
        define_method("#{field}=") do |field_value|
          write_attribute field.to_sym, field_value ? field_value.gsub(/\D/, "") : nil
        end
      end
    end

    def self.decimal_value(*fields)
      fields = [fields] unless fields.is_a?(Array)
      fields.each do |field|
        define_method("#{field}=") do |field_value|
          write_attribute field.to_sym, field_value ? field_value.to_s.safe_to_big_decimal : nil
        end
      end
    end

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