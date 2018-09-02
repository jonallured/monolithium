class Game < ActiveRecord::Base
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  belongs_to :week

  def winning_team
    if complete?
      home_score > away_score ? home_team : away_team
    end
  end

  def losing_team
    if complete?
      home_score < away_score ? home_team : away_team
    end
  end

  def delta
    if complete?
      (home_score - away_score).abs
    end
  end

  def complete?
    !!(home_score && away_score)
  end

  def teams
    [home_team, away_team].compact
  end
end
