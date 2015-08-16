FactoryGirl.define do
  factory :classroom do
    sequence(:identifier) { |i| i.to_s }
  end
end
