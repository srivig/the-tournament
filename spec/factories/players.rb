require 'faker'

FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    group {Faker::Address.country}
    sequence(:seed) {|i| i }
  end
end
