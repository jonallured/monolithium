class Crud::BoopsController < ApplicationController
  expose(:boop)
  expose(:boops) do
    Boop.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_boop_path(Boop.random) if random_id?
  end

  def create
    if boop.save
      flash.notice = "Boop created"
      redirect_to crud_boop_path(boop)
    else
      flash.alert = boop.errors.full_messages.to_sentence
      redirect_to new_crud_boop_path
    end
  end

  def update
    if boop.update(boop_params)
      flash.notice = "Boop updated"
      redirect_to crud_boop_path(boop)
    else
      flash.alert = boop.errors.full_messages.to_sentence
      redirect_to edit_crud_boop_path(boop)
    end
  end

  def destroy
    boop.destroy
    flash.notice = "Boop deleted"
    redirect_to crud_boops_path
  end

  private

  def boop_params
    params.require(:boop).permit(Boop.permitted_params)
  end
end
