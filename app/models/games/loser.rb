#coding: utf-8
class Loser < Game
  def parent_match_id
    if self.round%2 == 1
      self.match
    else
      (self.match%2 == 1) ? (self.match+1)/2 : (self.match)/2
    end
  end

  def parent_record_num
    (self.semi_final?) ? 2 : 1  # return 2 for final game, 1 for other loser games
  end

  def loser_game
    if self.semi_final?
      self.tournament.third_place
    end
  end

  def loser_record_num
    2 if self.semi_final?   # used only for third_place
  end

  def final?
    false   # final never comes in losers bracket
  end

  def semi_final?
    self.round == self.tournament.loser_round_num
  end

  def third_place?
    false   # third_place never comes in losers bracket
  end
end
