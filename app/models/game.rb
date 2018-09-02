class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  belongs_to :week

  def winning_team
    return nil unless complete?
    home_score > away_score ? home_team : away_team
  end

  def losing_team
    return nil unless complete?
    home_score < away_score ? home_team : away_team
  end

  def delta
    return nil unless complete?
    (home_score - away_score).abs
  end

  def complete?
    [home_score, away_score].all?(&:present?)
  end

  def teams
    [home_team, away_team].compact
  end
end
