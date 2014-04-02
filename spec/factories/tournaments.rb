# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tournament do
    association :user
    title {Faker::Company.name}
    size 8
    secondary_final true
  end
end
