class BoopsController < ApplicationController
  skip_before_action :ensure_admin

  expose(:boop)
  expose(:pending_boops) { Boop.pending }

  def create
    boop.number = Boop.next_number
    if boop.save
      flash.notice = "Boop created!"
    else
      flash.alert = boop.errors.full_messages.to_sentence
    end

    redirect_to boops_path
  end

  private

  def boop_params
    params.require(:boop).permit(:display_type)
  end
end
