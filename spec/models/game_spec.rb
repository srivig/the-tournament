require 'spec_helper'

describe Game do
  describe 'basic validation' do
    before :each do
      @user = create(:user)
      @tournament = create(:tournament, user:@user)
    end

    it 'should be valid with proper attr' do
      game = build(:game, tournament:@tournament)
      expect(game).to be_valid
    end

    it 'should not be valid without bracket' do
      expect(build(:game, bracket:0)).to have(1).errors_on(:bracket)
    end
  end

  describe 'parent' do
    before :each do
      @user = create(:user)
      @tournament = create(:tournament, user:@user, size:8)
    end

    context 'when not in final round' do
      subject { @tournament.games.find_by(bracket:1, round:1, match:1) }

      it 'should return parent game' do
        expect(subject.parent).to eq(@tournament.games.find_by(bracket:1, round:2, match:1))
      end
    end

    context 'when in final round' do
      subject { @tournament.games.find_by(bracket:1, round:3, match:1) }

      it 'should return nil' do
        expect(subject.parent).to eq(nil)
      end
    end
  end

  describe 'ancestors' do
    before :each do
      @user = create(:user)
      @tournament = create(:tournament, user:@user, size:8)
    end

    context 'case 1-1' do
      subject { @tournament.games.find_by(bracket:1, round:1, match:1) }

      it 'should return right ancestors' do
        ancestors = [
          @tournament.games.find_by(bracket:1, round:2, match:1),
          @tournament.games.find_by(bracket:1, round:3, match:1),
          @tournament.games.find_by(bracket:1, round:3, match:2)
        ]
        expect(subject.ancestors).to eq(ancestors)
      end
    end

    context 'case 1-4' do
      subject { @tournament.games.find_by(bracket:1, round:1, match:4) }

      it 'should return right ancestors' do
        ancestors = [
          @tournament.games.find_by(bracket:1, round:2, match:2),
          @tournament.games.find_by(bracket:1, round:3, match:1),
          @tournament.games.find_by(bracket:1, round:3, match:2)
        ]
        expect(subject.ancestors).to eq(ancestors)
      end
    end
  end

  describe 'finished?' do
    context 'when the game is finished' do
      it 'should return true' do
        @game = create(:game_with_winner)
        expect(@game.finished?).to be_true
      end
    end

    context 'when the game is not finished' do
      it 'should return false' do
        @game = create(:game_with_empty_records)
        expect(@game.finished?).to be_false
      end
    end
  end

  describe 'winner' do
    context 'when winner exist' do
      it 'should have winner' do
        @game = create(:game_with_winner)
        expect(@game.winner).to eq(@game.game_records.first.player)
      end
    end

    context 'when winner not exist' do
      it 'should return nil' do
        @game = create(:game_with_empty_records)
        expect(@game.winner).to eq(nil)
      end
    end
  end

  describe 'loser' do
    context 'when winner exist' do
      it 'should return loser' do
        @game = create(:game_with_winner)
        expect(@game.loser).to eq(@game.game_records.last.player)
      end
    end

    context 'when winner not exist' do
      it 'should return nil' do
        @game = create(:game_with_empty_records)
        expect(@game.loser).to eq(nil)
      end
    end
  end

  describe 'semi_final?' do
    before :each do
      @user = create(:user)
      @tournament = create(:tournament, user:@user, size:8)
    end

    context 'when in semi_final' do
      subject { @tournament.games.find_by(bracket:1, round:2, match:1) }
      it 'should return true' do
        expect(subject.semi_final?).to be_true
      end
    end

    context 'when not in semi_final' do
      subject { @tournament.games.find_by(bracket:1, round:1, match:1) }
      it 'should return false' do
        expect(subject.semi_final?).to be_false
      end
    end
  end


  describe 'final?' do
    before :each do
      @user = create(:user)
      @tournament = create(:tournament, user:@user, size:8)
    end

    context 'when in final' do
      subject { @tournament.games.find_by(bracket:1, round:3, match:1) }
      it 'should return true' do
        expect(subject.final?).to be_true
      end
    end

    context 'when not in final' do
      subject { @tournament.games.find_by(bracket:1, round:1, match:1) }
      it 'should return false' do
        expect(subject.final?).to be_false
      end
    end
  end


  describe 'winner_changed?' do
    before :each do
      @game = create(:game_with_winner)
    end

    context 'when winner changed' do
      before :each do
        @game.game_records.first.winner = false
        @game.game_records.second.winner = true
        @game.save
      end

      it 'should return true' do
        expect(@game.winner_changed?).to be_true
      end
    end

    context 'when winner not changed' do
      it 'should return false' do
        expect(@game.winner_changed?).to be_false
      end
    end
  end

  describe 'has_valid_winner' do
    before :each do
      @game = create(:game_with_winner)
      @game.game_records.find_by(winner: true).winner = false
    end

    it 'should not be valid without winner' do
      pending 'cannot test has_valid_winner'
      @game.save!
      # expect(@game.game_records).to
    end
  end

  describe 'reset ancestors'

  describe 'set parent game'
end
