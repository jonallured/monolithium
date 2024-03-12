class CrankCountsController < ApplicationController
  skip_before_action :ensure_admin

  expose(:crank_user, find_by: :code, id: :crank_user_code)
  expose(:crank_count, parent: :crank_user)

  def create
    if crank_count.save
      flash.notice = "Crank Count created"
      redirect_to crank_user_crank_count_path(crank_user, crank_count)
    else
      flash.alert = crank_count.errors.full_messages.to_sentence
      redirect_to new_crank_user_crank_count_path(crank_user)
    end
  end

  private

  def crank_count_params
    params.require(:crank_count).permit(:ticks).merge(cranked_on: Date.today)
  end
end
