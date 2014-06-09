require 'faker'

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "hogehoge#{n}@example.com"
    end
    password "hogehoge"
    password_confirmation "hogehoge"
    admin false
    # provider "facebook"
    # uid { Faker::Number.number(10) }
  end
end
