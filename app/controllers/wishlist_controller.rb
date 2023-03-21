class WishlistController < ApplicationController
  skip_before_action :ensure_admin

  expose(:available_gift_ideas) do
    ideas = admin? ? GiftIdea.not_received : GiftIdea.available
    ideas.order(:created_at)
  end

  expose(:claimed_gift_ideas) do
    admin? ? [] : GiftIdea.claimed.order(:claimed_at)
  end

  expose(:received_gift_ideas) do
    admin? ? GiftIdea.received.order(:received_at) : []
  end
end
