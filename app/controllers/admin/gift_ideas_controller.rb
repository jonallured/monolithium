class Admin::GiftIdeasController < ApplicationController
  expose(:gift_idea)
  expose(:gift_ideas) { GiftIdea.all.limit(10) }

  def create
    if gift_idea.save
      redirect_to admin_gift_idea_path(gift_idea)
    else
      flash.alert = gift_idea.errors.full_messages
      render :new
    end
  end

  def update
    if gift_idea.update(gift_idea_params)
      redirect_to admin_gift_idea_path(gift_idea)
    else
      flash.alert = gift_idea.errors.full_messages
      render :edit
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
