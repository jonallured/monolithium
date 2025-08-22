module Api
  module V1
    class VanishingMessagesController < Api::V1Controller
      def create
        head :bad_request and return unless params[:body].present?

        payload = {
          body: params[:body],
          created_at: Time.now.to_fs
        }
        VanishingBoxChannel.broadcast(payload)
        head :created
      end
    end
  end
end
