# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  tournament_id :integer
#  bracket       :integer
#  round         :integer
#  match         :integer
#  bye           :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  type          :string(255)      default("Winner")
#

#coding: utf-8
class Winner < Game
  def parent_match_id
    (self.match%2 == 1) ? (self.match+1)/2 : (self.match)/2
  end

  def parent_record_num
    ((self.match)%2 == 1) ? 1 : 2   # return 1 for odd number, 2 for even number
  end

  def loser_game
    if self.tournament.de?
      round_num = self.loser_round_num
      match_num = self.loser_match_num
      self.tournament.games.find_by(bracket:2, round:round_num, match:match_num)
    elsif self.semi_final?
      self.tournament.third_place
    end
  end

  def loser_round_num
    [(self.round-1)*2, 1].max # 1,2,4,6,8,...
  end

  def loser_match_num
    if self.round == 1
      ((self.match)%2 == 0) ? (self.match)/2 : (self.match+1)/2
    elsif self.round%2 == 0
      match_num = self.tournament.games.where(bracket:2, round:self.loser_round_num).count
      (match_num+1) - self.match
    else
      self.match
    end
  end

  def loser_record_num
    if self.tournament.de?
      # Loser Bracket: 1st roundはrecord_numは1,2ともあり。2nd以降はrecord_num=2にセット
      if self.round == 1 && (self.match)%2 != 0
        1
      else
        2
      end
    else
      self.match if self.semi_final?
    end
  end

  def third_place_record_num
    if self.tournament.de?
      1
    else
      unless self.final?
        half_num = self.tournament.games.where(round: self.round).count / 2  # in size8, return 2 for 1st round, 1 for 2nd,
        (self.match <= half_num) ? 1 : 2
      end
    end
  end

  def final?
    if self.tournament.de?
      false
    else
      (self.round==self.tournament.round_num) && (self.match==1)
    end
  end

  def semi_final?
    if self.tournament.de?
      self.round == self.tournament.round_num
    else
      self.round == self.tournament.round_num - 1
    end
  end

  def third_place?
    if self.tournament.de?
      false
    else
      (self.round==self.tournament.round_num) && (self.match==2)
    end
  end
end
