module Api
  module V1
    module CurrentSeason
      class ActiveTeamsController < Api::V1::CurrentSeasonController
        expose(:week) do
          current_season.weeks.find_by number: params[:week_number]
        end
        expose(:active_teams) { week.active_teams }
      end
    end
  end
end
