# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    association :party
    rule "Eight-ball"

    after(:build) do |game|
      game.game_records << build(:game_record, user: create(:user))
      game.game_records << build(:win_record, user: create(:user))
    end
  end

  factory :game_with_no_winner, class: Game do
    association :party
    rule "Eight-ball"

    after(:build) do |game|
      game.game_records << build(:game_record, user: create(:user))
      game.game_records << build(:game_record, user: create(:user))
    end
  end

  factory :game_with_two_winners, class: Game do
    association :party
    rule "Eight-ball"

    after(:build) do |game|
      game.game_records << build(:win_record, user: create(:user))
      game.game_records << build(:win_record, user: create(:user))
    end
  end
end
