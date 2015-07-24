FactoryGirl.define do
  factory :administrator do
    name 'MyString'
    sequence(:email) { |sequence| "email_#{sequence}@email.com" }
    password 'super strong password'
  end
end
