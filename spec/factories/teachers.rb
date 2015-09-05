FactoryGirl.define do
  factory :teacher do
    name 'MyString'
    gender 0
    sequence(:email) { |i| "email_#{i}@email.com" }
    password 'deleatur1234'
    cpf { BrFaker::Cpf.cpf }
    phone '5498962123'
    birth_date '2000-08-07'
  end
end
