class CurrentPick
  attr_accessor :pick

  delegate :team, :week, to: :pick

  def initialize(pick)
    @pick = pick
  end

  def week_number
    week.number
  end

  def team_id
    team.id
  end
end

