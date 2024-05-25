class Crud::SneakersController < ApplicationController
  expose(:sneaker)
  expose(:sneakers) do
    Sneaker.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_sneaker_path(Sneaker.random) if params[:id] == "random"
  end

  def create
    if sneaker.save
      flash.notice = "Sneaker created"
      redirect_to crud_sneaker_path(sneaker)
    else
      flash.alert = sneaker.errors.full_messages.to_sentence
      redirect_to new_crud_sneaker_path
    end
  end

  def update
    if sneaker.update(sneaker_params)
      flash.notice = "Sneaker updated"
      redirect_to crud_sneaker_path(sneaker)
    else
      flash.alert = sneaker.errors.full_messages.to_sentence
      redirect_to edit_crud_sneaker_path(sneaker)
    end
  end

  def destroy
    sneaker.destroy
    flash.notice = "Sneaker deleted"
    redirect_to crud_sneakers_path
  end

  private

  def sneaker_params
    params.require(:sneaker).permit(:amount_cents, :details, :image, :name, :ordered_on)
  end
end
