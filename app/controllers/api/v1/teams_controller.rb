module Api
  module V1
    class TeamsController < Api::V1Controller
      expose(:teams) { Team.all }
    end
  end
end
