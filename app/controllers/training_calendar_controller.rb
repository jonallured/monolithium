class TrainingCalendarController < ApplicationController
  expose(:calendar_report) do
    year = params[:year]
    month = params[:month]
    TrainingDay::CalendarReport.new(year, month)
  end
end
