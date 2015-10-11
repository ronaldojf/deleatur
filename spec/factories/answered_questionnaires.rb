FactoryGirl.define do
  factory :answered_questionnaire do
    status 0
    points 1
    association(:questionnaire)
    association(:student)
  end
end
