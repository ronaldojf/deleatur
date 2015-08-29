require 'rails_helper'

RSpec.describe Utils::AttributesCleaner, :type => :unit do
  describe '.only_digits' do
    subject(:example) { build :teacher, phone: 'abc123' }

    it "does change the method to get only the numbers" do
      expect(example.phone).to eq '123'
    end
  end

  # WRITE THIS TEST WHEN HAVE ANYTHING WITH A DECIMAL VALUE
  # describe '.decimal_value' do
  #   subject(:example) { build :teacher, money: 'R$ 123,20' }

  #   it "does change the method to get only the numbers" do
  #     expect(example.money).to eq 123.20
  #   end
  # end
end
