FactoryGirl.define do
  factory :answer do
    association(:question_option)
    association(:answered_questionnaire)
  end
end
