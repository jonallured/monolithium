class GiftIdeasController < ApplicationController
  skip_before_action :ensure_admin

  expose(:gift_idea)

  def update
    if gift_idea.update(gift_idea_params)
      flash.notice = "Gift Idea updated"
    else
      flash.alert = gift_idea.errors.full_messages.to_sentence
    end

    redirect_to wishlist_path
  end

  private

  def gift_idea_params
    params.require(:gift_idea).permit(:claimed_at, :received_at)
  end
end
