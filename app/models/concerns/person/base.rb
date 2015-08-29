module Person::Base
  extend ActiveSupport::Concern

  included do
    def formatted_phone
      cleaned_phone = self.phone.to_s.gsub(/\D/, '')
      Phonie.configure { |c| c.n1_length = (cleaned_phone.size > 10) ? 5 : 4 }
      Phonie::Phone.parse(cleaned_phone).try(:format, :br)
    end

    def formatted_cpf
      Cpf.new(self.cpf).to_s
    end
  end
end