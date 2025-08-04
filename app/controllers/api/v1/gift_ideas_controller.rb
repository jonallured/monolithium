module Api
  module V1
    class GiftIdeasController < Api::V1Controller
      expose(:gift_idea, with: :random_or_find)

      expose(:gift_ideas) do
        GiftIdea.order(created_at: :desc).page(params[:page])
      end

      def create
        gift_idea.save!
        render :show, status: :created
      end

      def update
        gift_idea.update!(gift_idea_params)
        render :show
      end

      def destroy
        gift_idea.destroy
        head :ok
      end

      private

      def gift_idea_params
        params.require(:gift_idea).permit(
          :note,
          :title,
          :website_url
        )
      end
    end
  end
end
