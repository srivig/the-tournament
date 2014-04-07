# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :base_tnmt, class: 'Tournament' do
    association :user
    title {Faker::Company.name}
    size 8
    consolation_round true
    secondary_final false
  end

  factory :tournament, parent: :base_tnmt, class: 'SingleElimination' do
    type 'SingleElimination'
  end

  factory :de_tnmt, parent: :tournament, class: 'DoubleElimination' do
    type 'DoubleElimination'
  end
end
