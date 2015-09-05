FactoryGirl.define do
  factory :student do
    name 'MyString'
    gender 0
    sequence(:email) { |i| "email_#{i}@email.com" }
    password 'deleatur1234'
    birth_date '2000-08-12'
    association :classroom, factory: :classroom
  end
end
