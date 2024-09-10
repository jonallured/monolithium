module Api
  module V1
    class DecodeJwtController < Api::V1Controller
      skip_before_action :validate_client_token

      def show
        render json: decoded_jwt
      rescue JWT::DecodeError
        head :bad_request
      end

      private

      def decoded_jwt
        jwt_payload, jwt_headers = JWT.decode(params[:token], nil, false)

        {
          headers: jwt_headers,
          payload: jwt_payload,
          token: params[:token]
        }
      end
    end
  end
end
