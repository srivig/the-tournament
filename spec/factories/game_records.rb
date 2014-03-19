# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_record do
    association :player
    association :game
    score 0
    record_num 1

    factory :win_record do
      score 1
      winner true
    end

    factory :lose_record do
      winner false
    end
  end
end
