FactoryGirl.define do
  factory :answered_questionnaire do
    status 0
    association(:questionnaire)
    association(:student)
  end
end
