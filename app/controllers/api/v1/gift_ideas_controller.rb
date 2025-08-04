module Api
  module V1
    class GiftIdeasController < Api::V1Controller
      expose(:gift_idea, with: :random_or_find)

      expose(:gift_ideas) do
        GiftIdea.order(created_at: :desc).page(params[:page])
      end
    end
  end
end
