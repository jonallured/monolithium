class Pick < ApplicationRecord
  belongs_to :character
  belongs_to :week
  belongs_to :team

  delegate :delta, to: :game
  delegate :complete?, to: :game, prefix: true

  def correct?
    game.winning_team == team
  end

  def score
    PickScore.for self
  end

  private

  def game
    @game ||= week.game_for team
  end
end
