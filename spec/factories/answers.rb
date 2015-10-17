FactoryGirl.define do
  factory :answer do
    association(:question_option)
  end
end
