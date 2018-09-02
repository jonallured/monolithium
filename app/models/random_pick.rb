class RandomPick < ApplicationRecord
  belongs_to :week
  belongs_to :team

  def correct?
    game.winning_team == team
  end

  def to_i
    correct? ? 1 : -1
  end

  def game
    @game ||= week.game_for team
  end
end
