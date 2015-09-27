FactoryGirl.define do
  factory :subject do
    sequence(:description) { |i| "MyString_#{i}" }
  end
end
