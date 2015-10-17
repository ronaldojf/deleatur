FactoryGirl.define do
  factory :pontuation do
    points '9.99'
    association(:answered_questionnaire)
    association(:student)
  end
end
