module Api
  class TeamsController < ApiController
    expose(:teams) { Team.all }
  end
end
