module Api
  module V1
    class VanishingMessagesController < Api::V1Controller
      def create
        head :bad_request and return unless params[:secret].present?

        VanishingMessage.fire_and_forget(params[:secret])
        head :created
      end
    end
  end
end
