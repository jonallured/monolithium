class CurrentPick
  attr_accessor :pick

  delegate :team, :week, to: :pick
  delegate :number, to: :week, prefix: true
  delegate :id, to: :team, prefix: true

  def initialize(pick)
    @pick = pick
  end
end
