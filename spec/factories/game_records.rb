# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_record do
    association :player
    association :game
    record_num 1
    score nil

    factory :win_record do
      score 1
      winner true
    end

    factory :lose_record do
      score 0
      winner false
    end
  end
end
