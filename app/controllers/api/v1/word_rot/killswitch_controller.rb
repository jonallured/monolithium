module Api
  module V1
    module WordRot
      class KillswitchController < Api::V1Controller
        skip_before_action :validate_client_token

        def show
          killswitch = Killswitch.instance
          render json: killswitch.as_json(only: %i[bad_builds minimum_build])
        end
      end
    end
  end
end
