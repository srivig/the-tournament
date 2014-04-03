require 'spec_helper'

describe Tournament do
  describe 'basic validations' do
    before :each do
      @user = create(:user)
    end

    it 'is valid with a proper attrs' do
      tournament = build(:tournament, user:@user)
      expect(tournament).to be_valid
    end

    it 'is invalid without a user_id' do
      expect(build(:tournament, user:nil)).to have(1).errors_on(:user_id)
    end

    it 'should has a size in a multiplier of 2' do
      expect(build(:tournament, user:@user, size:5)).to have(1).errors_on(:size)
    end

    describe 'method after creation' do
      before :each do
        @user = create(:user)
        @tournament = create(:se_tnmt, user:@user)
      end

      it 'should order from the newest' do
        2.times do |i|
          create(:se_tnmt, user:@user)
        end
        expect(Tournament.last).to eq(@tournament)
      end
    end
  end

  # describe 'create_players' do
  #   before :each do
  #     @user = create(:user)
  #     @tournament = create(:tournament, user:@user, size:8)
  #   end

  #   it 'should have players equal to its size' do
  #     expect(@tournament.players.size).to eq(8)
  #   end
  # end

  # describe 'create_games' do
  #   context 'when it has a third-party placement' do
  #     before :each do
  #       @user = create(:user)
  #       @tournament = create(:tournament, user:@user, size:8)
  #       p @tournament.games
  #     end

  #     it 'should have right number of games' do
  #       expect(@tournament.games.size).to eq(8)
  #     end
  #   end
  # end

  # describe 'round_num' do
  #   before :each do
  #     @user = create(:user)
  #   end

  #   context 'when it has a third-party placement' do
  #     it 'should return the correct round num' do
  #       [2,3,4].each do |i|
  #         tournament = create(:tournament, user:@user, size:2**i)
  #         expect(tournament.round_num).to eq(i)
  #       end
  #     end
  #   end
  # end

  # describe 'third-place' do
  #   before :each do
  #     @user = create(:user)
  #   end

  #   context 'when it has a third-party placement' do
  #     it 'should return the game for the third-place playoff' do
  #       @tournament = create(:tournament, user:@user, size:8)
  #       expect(@tournament.third_place).to eq(@tournament.games.find_by(bracket:1, round:3, match:2))
  #     end
  #   end
  # end

  # describe 'set_first_rounds' do
  #   before :each do
  #     @user = create(:user)
  #     @tournament = create(:tournament, user:@user)
  #   end

  #   it 'should have first-round game with game_records' do
  #     @tournament.games.where(round:1).each do |game|
  #       expect(game.game_records.size).to be > 0
  #     end
  #   end
  # end
end
