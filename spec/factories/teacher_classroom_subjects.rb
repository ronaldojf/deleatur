FactoryGirl.define do
  factory :teacher_classroom_subject do
    association(:teacher)
    association(:classroom)
    association(:subject)
  end
end
