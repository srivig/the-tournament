# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tournament, class: 'Tournament' do
    association :user
    title {Faker::Company.name}
    size 8
    consolation_round true
    secondary_final false
  end

  factory :se_tnmt, parent: :tournament, class: 'SingleElimination' do
    type 'SingleElimination'
  end

  factory :de_tnmt, parent: :tournament, class: 'DoubleElimination' do
    type 'DoubleElimination'
  end
end
