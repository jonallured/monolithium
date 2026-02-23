class Crud::ChoresController < ApplicationController
  expose(:chore)
  expose(:chores) do
    Chore.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_chore_path(Chore.random) if random_id?
  end

  def create
    if chore.save
      flash.notice = "Chore created"
      redirect_to crud_chore_path(chore)
    else
      flash.alert = chore.errors.full_messages.to_sentence
      redirect_to new_crud_chore_path
    end
  end

  def update
    if chore.update(chore_params)
      flash.notice = "Chore updated"
      redirect_to crud_chore_path(chore)
    else
      flash.alert = chore.errors.full_messages.to_sentence
      redirect_to edit_crud_chore_path(chore)
    end
  end

  def destroy
    chore.destroy
    flash.notice = "Chore deleted"
    redirect_to crud_chores_path
  end

  private

  def chore_params
    permitted_params = params.require(:chore).permit(Chore.permitted_params)
    due_days = Chore.day_names_to_numbers(params[:chore][:due_days])
    permitted_params[:due_days] = due_days
    permitted_params
  end
end
