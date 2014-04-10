#coding: utf-8
class Winner < Game
  def parent_match_id
    (self.match%2 == 1) ? (self.match+1)/2 : (self.match)/2
  end

  def parent_record_num
    ((self.match)%2 == 0) ? 2 : 1   # return 1 for odd number, 2 for even number
  end

  def loser_game
    if self.semi_final?
      self.tournament.third_place
    elsif self.tournament.de?
      round_num = [(self.round-1)*2, 1].max # 1,2,4,6,8,...
      match_num = ((self.match)%2 == 0) ? (self.match)/2 : (self.match+1)/2
      self.tournament.games.find_by(bracket:2, round:round_num, match:match_num)
    end
  end

  def loser_record_num
    if self.semi_final?
      # Third Place:
      if self.tournament.de?
        self.bracket # return 1 for winner's loser, 2 for loser's loser
      else
        self.match
      end
    else
      # Loser Bracket: 1st roundはrecord_numは1,2ともあり。2nd以降はrecord_num=2にセット
      if self.round == 1 && (self.match)%2 != 0
        1
      else
        2
      end
    end
  end

  def final?
    unless self.tournament.de?
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
    unless self.tournament.de?
      (self.round==self.tournament.round_num) && (self.match==2)
    end
  end
end
