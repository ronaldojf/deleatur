module Utils::AttributesCleaner
  extend ActiveSupport::Concern

  class_methods do
    def only_digits(*fields)
      fields = [fields] unless fields.is_a?(Array)
      fields.each do |field|
        define_method("#{field}=") do |field_value|
          write_attribute field.to_sym, field_value ? field_value.gsub(/\D/, '') : nil
        end
      end
    end

    # UNCOMMENT THIS AND DO THE TESTS OF WHEN HAVE ANYTHING WITH A ATTRIBUTE WITH TYPE DECIMAL NUMBER
    # def decimal_value(*fields)
    #   fields = [fields] unless fields.is_a?(Array)
    #   fields.each do |field|
    #     define_method("#{field}=") do |field_value|
    #       cleaned_value = field_value.to_s
    #         .gsub(',', '.')
    #         .split('.')
    #         .collect { |value| value.gsub(/\D/, '') }
    #         .join('.')
    #         .to_f

    #       write_attribute field.to_sym, field_value ? cleaned_value : nil
    #     end
    #   end
    # end
  end
end