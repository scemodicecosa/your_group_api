FactoryBot.define do
  factory :group do
    name FFaker::Lorem.word
    description FFaker::Lorem.word
  end
end
