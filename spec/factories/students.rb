FactoryGirl.define do
  factory :student do
    name 'MyString'
    gender 0
    sequence(:email) { |i| 'email_#{i}@email.com' }
    birth_date '2000-08-12'
    association :classroom, factory: :classroom
  end
end
