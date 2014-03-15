# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tournament do
    association :user
    title {Faker::Company.name}
    size 8

    # after(:build) do |game|
    #   game.game_records << build(:game_record, user: create(:user))
    #   game.game_records << build(:win_record, user: create(:user))
    # end
  end
end
