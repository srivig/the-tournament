# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_record do
    association :user

    factory :win_record do
      winner true
    end

    factory :game_record_for_controller do
      user_name 'hoge'
      factory :win_record_for_controller do
        winner true
      end
    end
  end
end
