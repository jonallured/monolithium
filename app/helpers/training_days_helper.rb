module TrainingDaysHelper
  CALENDAR_COLORS = {
    filler: "bg-black",
    going: "bg-dark-gray",
    missed: "bg-white",
    went: "bg-purple"
  }

  WEEK_COLORS = {
    going: "text-off-white",
    missed: "text-black",
    went: "text-off-white"
  }

  def calendar_color(outcome)
    CALENDAR_COLORS[outcome]
  end

  def week_color(outcome)
    WEEK_COLORS[outcome]
  end
end
