# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    association :tournament
    bracket 1
    round 1
    match 1
    type 'Winner'

    factory :game_with_empty_records do
      after(:build) do |game|
        game.game_records << build(:game_record, player: create(:player), record_num:1)
        game.game_records << build(:game_record, player: create(:player), record_num:2)
      end
    end

    factory :game_with_winner do
      after(:build) do |game|
        game.game_records << build(:win_record, player: create(:player), record_num:1)
        game.game_records << build(:lose_record, player: create(:player),record_num:2)
      end
    end

    factory :game_with_invalid_winner do
      after(:build) do |game|
        game.game_records << build(:win_record, player: create(:player), record_num:1, score:1)
        game.game_records << build(:lose_record, player: create(:player),record_num:2, score:2)
      end
    end
  end
end
