class Crud::WorkoutsController < ApplicationController
  expose(:workout)
  expose(:workouts) do
    Workout.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_workout_path(Workout.random) if random_id?
  end

  def create
    if workout.save
      flash.notice = "Workout created"
      redirect_to crud_workout_path(workout)
    else
      flash.alert = workout.errors.full_messages.to_sentence
      redirect_to new_crud_workout_path
    end
  end

  def update
    if workout.update(workout_params)
      flash.notice = "Workout updated"
      redirect_to crud_workout_path(workout)
    else
      flash.alert = workout.errors.full_messages.to_sentence
      redirect_to edit_crud_workout_path(workout)
    end
  end

  def destroy
    workout.destroy
    flash.notice = "Workout deleted"
    redirect_to crud_workouts_path
  end

  private

  def workout_params
    params.require(:workout).permit(Workout.permitted_params)
  end
end
