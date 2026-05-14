class TrainingWeekController < ApplicationController
  layout "wide"

  expose(:week_report) do
    year = params[:year]
    number = params[:number]
    TrainingDay::WeekReport.new(year, number)
  end
end
