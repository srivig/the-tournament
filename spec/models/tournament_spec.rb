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

    it 'should order from the newest' do
      2.times do |i|
        create(:tournament, user:@user)
      end
      expect(Tournament.first.id - Tournament.last.id).to eq(1)
    end
  end

  describe 'round_num' do
    before :each do
      @user = create(:user)
    end

    it 'should return the correct round num' do
      [2,3,4].each do |i|
        tournament = create(:tournament, user:@user, size:2**i)
        expect(tournament.round_num).to eq(i)
      end
    end
  end

end
