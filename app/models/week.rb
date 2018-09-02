class Week < ApplicationRecord
  belongs_to :season
  has_many :games, dependent: :destroy
  has_many :picks, dependent: :destroy
  has_one :random_pick, dependent: :destroy

  def scoring_week
    !random_pick.correct?
  end

  def game_for(team)
    games.find_by('home_team_id = ? OR away_team_id = ?', team.id, team.id)
  end

  def next_week
    season.weeks.find_by(number: number + 1)
  end

  def prev_week
    season.weeks.find_by(number: number - 1)
  end

  def complete?
    games.all?(&:complete?)
  end

  def active_teams
    games.map(&:teams).flatten.map(&:id).sort
  end
end
