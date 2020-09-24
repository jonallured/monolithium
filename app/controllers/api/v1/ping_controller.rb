module Api
  module V1
    class PingController < Api::V1Controller
      skip_before_action :validate_client_token

      def show
        render plain: Time.now.to_i
      end
    end
  end
end
