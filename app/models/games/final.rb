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
class Final < Game
  # final never use these method
  def parent_match_id
  end

  def parent_record_num
  end

  def loser_game
  end

  def loser_record_num
  end

  def third_place_record_num
  end

  def final?
    (self.match == 1) ? true : false
  end

  def semi_final?
    false
  end

  def third_place?
    (self.match == 2) ? true : false
  end
end
