module Api
  module CurrentSeason
    class ActiveTeamsController < Api::CurrentSeasonController
      expose(:week) do
        current_season.weeks.find_by number: params[:week_number]
      end
      expose(:active_teams) { week.active_teams }
    end
  end
end
