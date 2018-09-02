class Pick < ActiveRecord::Base
  belongs_to :character
  belongs_to :week
  belongs_to :team

  def correct?
    game.winning_team == team
  end

  def delta
    game.delta
  end

  def score
    PickScore.for self
  end

  def game_complete?
    game.complete?
  end

  private

  def game
    @game ||= week.game_for team
  end
end
