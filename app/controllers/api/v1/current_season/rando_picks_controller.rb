module Api
  module V1
    module CurrentSeason
      class RandoPicksController < Api::V1::CurrentSeasonController
        expose(:random_picks) do
          current_season.weeks.map(&:random_pick).compact
        end

        expose(:current_picks) do
          random_picks.map(&CurrentPick.method(:new))
        end

        def create
          team = Team.find params[:team_id]
          week = current_season.weeks.find_by number: params[:week_number]
          random_pick = RandomPick.new team: team, week: week

          if random_pick.save
            render :index, status: :created
          else
            # insert working code here
            render :something
          end
        end
      end
    end
  end
end
