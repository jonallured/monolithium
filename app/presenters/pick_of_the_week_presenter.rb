class PickOfTheWeekPresenter
  def initialize(games)
    @games = games.sort_by(&:delta)
  end

  def text
    if multiple_picks?
      "A tie! The #{winners} beat the #{losers} (respectively) by #{delta}"
    else
      "The #{winners} beat the #{losers} by #{delta}"
    end
  end

  private

  def winners
    joined_team_names :winners
  end

  def losers
    joined_team_names :losers
  end

  def winning_team_names
    picks_of_the_week.map(&:winning_team).pluck(:name)
  end

  def losing_team_names
    picks_of_the_week.map(&:losing_team).pluck(:name)
  end

  def delta
    games.last.delta
  end

  def multiple_picks?
    picks_of_the_week.count > 1
  end

  def picks_of_the_week
    games.select{ |game| game.delta == delta }
  end

  def games
    @games
  end

  def joined_team_names(team_type)
    team_names = team_type == :losers ? losing_team_names : winning_team_names
    joined_names(team_names)
  end

  def joined_names(team_names)
    return team_names.first if team_names.size == 1
    final = team_names.pop

    first = team_names.join(', ')
    [first, final].compact.join(' and ')
  end
end