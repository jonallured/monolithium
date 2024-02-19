class Admin::GiftIdeasController < ApplicationController
  expose(:gift_idea)
  expose(:gift_ideas) do
    GiftIdea.order(created_at: :desc).page(params[:page])
  end

  def create
    if gift_idea.save
      flash.notice = "Gift Idea created"
      redirect_to admin_gift_idea_path(gift_idea)
    else
      flash.alert = gift_idea.errors.full_messages.to_sentence
      redirect_to new_admin_gift_idea_path
    end
  end

  def update
    if gift_idea.update(gift_idea_params)
      flash.notice = "Gift Idea updated"
      redirect_to admin_gift_idea_path(gift_idea)
    else
      flash.alert = gift_idea.errors.full_messages.to_sentence
      redirect_to edit_admin_gift_idea_path(gift_idea)
    end
  end

  def destroy
    gift_idea.destroy
    flash.notice = "Gift Idea deleted"
    redirect_to admin_gift_ideas_path
  end

  private

  def gift_idea_params
    params.require(:gift_idea).permit(:title, :website_url, :note)
  end
end
