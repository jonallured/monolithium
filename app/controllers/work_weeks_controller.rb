class WorkWeeksController < ApplicationController
  expose(:work_week) do
    year, number = params[:target].split("-")
    WorkWeek.find_or_create(year, number)
  end
end
