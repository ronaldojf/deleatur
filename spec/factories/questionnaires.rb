FactoryGirl.define do
  factory :questionnaire do
    title 'MyString'
    published false
    association(:teacher)
    association(:classroom)
    association(:subject)
  end
end
