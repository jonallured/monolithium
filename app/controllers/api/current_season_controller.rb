module Api
  class CurrentSeasonController < ApiController
    expose(:current_season) { Season.current }
  end
end
