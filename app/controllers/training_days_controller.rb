class TrainingDaysController < ApplicationController
  expose(:training_day)

  def create
    year, month, _day = params[:training_day][:date].split("-").map(&:to_i)
    TrainingDay.populate(year, month)
    redirect_to training_calendar_path(year: year, month: month)
  end

  def update
    if training_day.update(training_day_params)
      flash.notice = "Training Day updated"
    else
      flash.alert = training_day.errors.full_messages.to_sentence
    end

    week_report_params = TrainingDay::WeekReport.params_for(training_day.date)
    redirect_to training_week_path(week_report_params)
  end

  private

  def training_day_params
    training_activity_params = [training_activities_attributes: [:_destroy, :id, :workout_id]]
    permitted_params = TrainingDay.permitted_params + training_activity_params
    params.require(:training_day).permit(permitted_params)
  end
end
