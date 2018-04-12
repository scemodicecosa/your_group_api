FactoryBot.define do
  factory :user do
    email {FFaker::Internet.email}
    password '12345678'
    password_confirmation '12345678'
    phone_number '3477956008'
  end
end
