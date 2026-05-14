class Crud::TrainingDaysController < ApplicationController
  expose(:training_day)
  expose(:training_days) do
    TrainingDay.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_training_day_path(TrainingDay.random) if random_id?
  end

  def create
    if training_day.save
      flash.notice = "Training Day created"
      redirect_to crud_training_day_path(training_day)
    else
      flash.alert = training_day.errors.full_messages.to_sentence
      redirect_to new_crud_training_day_path
    end
  end

  def update
    if training_day.update(training_day_params)
      flash.notice = "Training Day updated"
      redirect_to crud_training_day_path(training_day)
    else
      flash.alert = training_day.errors.full_messages.to_sentence
      redirect_to edit_crud_training_day_path(training_day)
    end
  end

  def destroy
    training_day.destroy
    flash.notice = "Training Day deleted"
    redirect_to crud_training_days_path
  end

  private

  def training_day_params
    params.require(:training_day).permit(TrainingDay.permitted_params)
  end
end
