module Api
  module V1
    class BoopsController < Api::V1Controller
      skip_before_action :validate_client_token, only: :create

      rate_limit to: 30, within: 1.minute, only: :create, with: -> { head :too_many_requests }

      expose(:boop, with: :random_or_find)

      expose(:boops) do
        Boop.order(created_at: :desc).page(params[:page])
      end

      def create
        boop.save!
        render :show, status: :created
      end

      def update
        boop.update!(boop_params)
        render :show
      end

      def destroy
        boop.destroy
        head :ok
      end

      private

      def boop_params
        params.require(:boop).permit(Boop.permitted_params)
      end
    end
  end
end
