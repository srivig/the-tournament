require 'faker'

FactoryGirl.define do
  factory :user do
    email "hogehoge@gmail.com"
    password "hogehoge"
    password_confirmation "hogehoge"
    admin false
    accept_terms true
    # provider "facebook"
    # uid { Faker::Number.number(10) }
  end
end
