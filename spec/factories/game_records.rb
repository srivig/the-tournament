# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_record do
    association :player
    association :game
    record_num 1

    factory :win_record do
      winner true
    end

    factory :lose_record do
      winner false
    end
  end
end
