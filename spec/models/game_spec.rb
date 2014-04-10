require 'spec_helper'

describe Game do
  before :each do
    @user = create(:user)
    @se_tnmt = create(:se_tnmt, user:@user)
    @de_tnmt = create(:de_tnmt, user:@user)
  end

  describe 'basic validation' do
    it 'should be valid with proper attr' do
      game = build(:game, tournament:@se_tnmt)
      expect(game).to be_valid
    end

    it 'should not be valid without bracket' do
      expect(build(:game, bracket:0, tournament:@se_tnmt)).to have(1).errors_on(:bracket)
    end
  end


  describe 'parent' do
    context 'when single elimination' do
      context 'when not in final round' do
        subject { @se_tnmt.games.find_by(bracket:1, round:1, match:1) }

        it 'should return parent game' do
          expect(subject.parent).to eq(@se_tnmt.games.find_by(bracket:1, round:2, match:1))
        end
      end

      context 'when in final round' do
        subject { @se_tnmt.games.find_by(bracket:1, round:3, match:1) }

        it 'should return nil' do
          expect(subject.parent).to eq(nil)
        end
      end
    end

    context 'when double elimination' do
      context 'when in winner bracket' do
        context 'when not in winner final round' do
          subject { @de_tnmt.games.find_by(bracket:1, round:1, match:1) }

          it 'should return parent game' do
            expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:1, round:2, match:1))
          end
        end

        context 'when in winner final round' do
          subject { @de_tnmt.games.find_by(bracket:1, round:3, match:1) }

          it 'should return final game' do
            expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:3, round:1, match:1))
          end
        end
      end

      context 'when in loser bracket' do
        context 'when not in loser final round' do
          subject { @de_tnmt.games.find_by(bracket:2, round:1, match:1) }

          it 'should return parent game' do
            expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:2, round:2, match:1))
          end
        end

        context 'when in loser middle round' do
          subject { @de_tnmt.games.find_by(bracket:2, round:2, match:2) }

          it 'should return parent game' do
            expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:2, round:3, match:1))
          end
        end

        context 'when in loser final round' do
          subject { @de_tnmt.games.find_by(bracket:2, round:4, match:1) }

          it 'should return final game' do
            expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:3, round:1, match:1))
          end
        end
      end
    end
  end


  describe 'parent_record' do
    context 'when single elimination' do
      context 'when not in final round' do
        subject { @se_tnmt.games.find_by(bracket:1, round:1, match:1) }

        it 'should return parent game record' do
          expect(subject.parent_record).to eq(@se_tnmt.games.find_by(bracket:1, round:2, match:1).game_records.find_by(record_num:1))
        end
      end

      # context 'when in final round' do
      #   subject { @se_tnmt.games.find_by(bracket:1, round:3, match:1) }

      #   it 'should return nil' do
      #     expect(subject.parent).to eq(nil)
      #   end
      # end
    end

    # context 'when double elimination' do
    #   context 'when in winner bracket' do
    #     context 'when not in winner final round' do
    #       subject { @de_tnmt.games.find_by(bracket:1, round:1, match:1) }

    #       it 'should return parent game' do
    #         expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:1, round:2, match:1))
    #       end
    #     end

    #     context 'when in winner final round' do
    #       subject { @de_tnmt.games.find_by(bracket:1, round:3, match:1) }

    #       it 'should return final game' do
    #         expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:3, round:1, match:1))
    #       end
    #     end
    #   end

    #   context 'when in loser bracket' do
    #     context 'when not in loser final round' do
    #       subject { @de_tnmt.games.find_by(bracket:2, round:1, match:1) }

    #       it 'should return parent game' do
    #         expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:2, round:2, match:1))
    #       end
    #     end

    #     context 'when in loser middle round' do
    #       subject { @de_tnmt.games.find_by(bracket:2, round:2, match:2) }

    #       it 'should return parent game' do
    #         expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:2, round:3, match:1))
    #       end
    #     end

    #     context 'when in loser final round' do
    #       subject { @de_tnmt.games.find_by(bracket:2, round:4, match:1) }

    #       it 'should return final game' do
    #         expect(subject.parent).to eq(@de_tnmt.games.find_by(bracket:3, round:1, match:1))
    #       end
    #     end
    #   end
    # end
  end


  describe 'ancestors' do
    context 'when single elimination' do
      context 'case 1-1' do
        subject { @se_tnmt.games.find_by(bracket:1, round:1, match:1) }

        it 'should return right ancestors' do
          ancestors = [
            @se_tnmt.games.find_by(bracket:1, round:3, match:1),
            @se_tnmt.games.find_by(bracket:1, round:3, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 1-4' do
        subject { @se_tnmt.games.find_by(bracket:1, round:1, match:4) }

        it 'should return right ancestors' do
          ancestors = [
            @se_tnmt.games.find_by(bracket:1, round:3, match:1),
            @se_tnmt.games.find_by(bracket:1, round:3, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 2-1' do
        subject { @se_tnmt.games.find_by(bracket:1, round:2, match:1) }

        it 'should return right ancestors' do
          expect(subject.ancestors).to eq([])
        end
      end
    end

    context 'when double elimination' do
      context 'case 1-1' do
        subject { @de_tnmt.games.find_by(bracket:1, round:1, match:1) }

        it 'should return right ancestors' do
          ancestors = [
            @de_tnmt.games.find_by(bracket:1, round:3, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 1-4' do
        subject { @de_tnmt.games.find_by(bracket:1, round:1, match:4) }

        it 'should return right ancestors' do
          ancestors = [
            @de_tnmt.games.find_by(bracket:1, round:3, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 2-2' do
        subject { @de_tnmt.games.find_by(bracket:1, round:2, match:2) }

        it 'should return right ancestors' do
          ancestors = [
            @de_tnmt.games.find_by(bracket:3, round:1, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 3-1' do
        subject { @de_tnmt.games.find_by(bracket:1, round:3, match:1) }

        it 'should return right ancestors' do
          ancestors = []
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 2-1-2' do
        subject { @de_tnmt.games.find_by(bracket:2, round:1, match:2) }

        it 'should return right ancestors' do
          ancestors = [
            @de_tnmt.games.find_by(bracket:2, round:3, match:1),
            @de_tnmt.games.find_by(bracket:2, round:4, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 2-2-1' do
        subject { @de_tnmt.games.find_by(bracket:2, round:2, match:1) }

        it 'should return right ancestors' do
          ancestors = [
            @de_tnmt.games.find_by(bracket:2, round:4, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 2-3-1' do
        subject { @de_tnmt.games.find_by(bracket:2, round:3, match:1) }

        it 'should return right ancestors' do
          ancestors = [
            @de_tnmt.games.find_by(bracket:3, round:1, match:1),
            @de_tnmt.games.find_by(bracket:3, round:1, match:2)
          ]
          expect(subject.ancestors).to eq(ancestors)
        end
      end

      context 'case 2-4-1' do
        subject { @de_tnmt.games.find_by(bracket:2, round:4, match:1) }

        it 'should return right ancestors' do
          ancestors = []
          expect(subject.ancestors).to eq(ancestors)
        end
      end
    end
  end


  describe 'finished?' do
    context 'when the game is finished' do
      it 'should return true' do
        @game = create(:game_with_winner, tournament:@se_tnmt)
        expect(@game.finished?).to be_true
      end
    end

    context 'when the game is not finished' do
      it 'should return false' do
        @game = create(:game_with_empty_records, tournament:@se_tnmt)
        expect(@game.finished?).to be_false
      end
    end
  end


  describe 'winner' do
    context 'when winner exist' do
      it 'should have winner' do
        @game = create(:game_with_winner, tournament:@se_tnmt)
        expect(@game.winner).to eq(@game.game_records.first.player)
      end
    end

    context 'when winner not exist' do
      it 'should return nil' do
        @game = create(:game_with_empty_records, tournament: @tournament)
        expect(@game.winner).to eq(nil)
      end
    end
  end


  describe 'loser' do
    context 'when winner exist' do
      it 'should return loser' do
        @game = create(:game_with_winner, tournament: @se_tnmt)
        expect(@game.loser).to eq(@game.game_records.last.player)
      end
    end

    context 'when winner not exist' do
      it 'should return nil' do
        @game = create(:game_with_empty_records, tournament:@tournament)
        expect(@game.loser).to eq(nil)
      end
    end
  end


  describe 'semi_final?' do
    context 'when in semi_final' do
      subject { @se_tnmt.games.find_by(bracket:1, round:2, match:1) }
      it 'should return true' do
        expect(subject.semi_final?).to be_true
      end
    end

    context 'when not in semi_final' do
      subject { @se_tnmt.games.find_by(bracket:1, round:1, match:1) }
      it 'should return false' do
        expect(subject.semi_final?).to be_false
      end
    end

    context 'when in semi_final in loser bracket' do
      subject { @de_tnmt.games.find_by(bracket:2, round:4, match:1) }
      it 'should return true' do
        expect(subject.semi_final?).to be_true
      end
    end

    context 'when in semi_final in winner bracket' do
      subject { @de_tnmt.games.find_by(bracket:1, round:3, match:1) }
      it 'should return true' do
        expect(subject.semi_final?).to be_true
      end
    end

    context 'when not in semi_final in loser bracket' do
      subject { @de_tnmt.games.find_by(bracket:2, round:3, match:1) }
      it 'should return false' do
        expect(subject.semi_final?).to be_false
      end
    end

    context 'when not in semi_final in winner bracket' do
      subject { @de_tnmt.games.find_by(bracket:1, round:2, match:1) }
      it 'should return false' do
        expect(subject.semi_final?).to be_false
      end
    end
  end


  describe 'final?' do
    context 'when in final' do
      subject { @se_tnmt.games.find_by(bracket:1, round:3, match:1) }
      it 'should return true' do
        expect(subject.final?).to be_true
      end
    end

    context 'when not in final' do
      subject { @se_tnmt.games.find_by(bracket:1, round:1, match:1) }
      it 'should return false' do
        expect(subject.final?).to be_false
      end
    end

    context 'when in final in de' do
      subject { @de_tnmt.games.find_by(bracket:3, round:1, match:1) }
      it 'should return true' do
        expect(subject.final?).to be_true
      end
    end

    context 'when not in final in de' do
      subject { @de_tnmt.games.find_by(bracket:1, round:3, match:1) }
      it 'should return false' do
        expect(subject.final?).to be_false
      end
    end
  end


  # describe 'winner_changed?' do
  #   before :each do
  #     @game = create(:game_with_winner)
  #   end

  #   context 'when winner changed' do
  #     before :each do
  #       @game.game_records.first.winner = false
  #       @game.game_records.second.winner = true
  #       @game.save
  #     end

  #     it 'should return true' do
  #       expect(@game.winner_changed?).to be_true
  #     end
  #   end

  #   context 'when winner not changed' do
  #     it 'should return false' do
  #       expect(@game.winner_changed?).to be_false
  #     end
  #   end
  # end

  # describe 'has_valid_winner' do
  #   before :each do
  #     @game = create(:game_with_winner)
  #     @game.game_records.find_by(winner: true).winner = false
  #   end

  #   it 'should not be valid without winner' do
  #     pending 'cannot test has_valid_winner'
  #     @game.save!
  #     # expect(@game.game_records).to
  #   end
  # end
end
