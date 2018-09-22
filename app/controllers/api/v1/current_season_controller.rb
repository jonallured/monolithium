module Api
  module V1
    class CurrentSeasonController < Api::V1Controller
      expose(:current_season) { Season.current }
    end
  end
end
