module Api
  module V1
    module CurrentSeason
      class PicksController < Api::V1::CurrentSeasonController
        expose(:character) { Character.find params[:character_id] }
        expose(:current_picks) do
          character.picks.map(&CurrentPick.method(:new))
        end

        def create
          team = Team.find params[:team_id]
          week = character.season.weeks.find_by number: params[:week_number]
          pick = character.picks.build team: team, week: week

          render :index, status: :created if pick.save
        end
      end
    end
  end
end
