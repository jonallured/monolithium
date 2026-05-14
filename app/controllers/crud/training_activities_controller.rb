class Crud::TrainingActivitiesController < ApplicationController
  expose(:training_activity)
  expose(:training_activities) do
    TrainingActivity.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_training_activity_path(TrainingActivity.random) if random_id?
  end

  def create
    if training_activity.save
      flash.notice = "Training Activity created"
      redirect_to crud_training_activity_path(training_activity)
    else
      flash.alert = training_activity.errors.full_messages.to_sentence
      redirect_to new_crud_training_activity_path
    end
  end

  def update
    if training_activity.update(training_activity_params)
      flash.notice = "Training Activity updated"
      redirect_to crud_training_activity_path(training_activity)
    else
      flash.alert = training_activity.errors.full_messages.to_sentence
      redirect_to edit_crud_training_activity_path(training_activity)
    end
  end

  def destroy
    training_activity.destroy
    flash.notice = "Training Activity deleted"
    redirect_to crud_training_activities_path
  end

  private

  def training_activity_params
    params.require(:training_activity).permit(TrainingActivity.permitted_params)
  end
end
