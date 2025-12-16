class AnalyticsReportsController < ApplicationController
  expose(:analytics_report) do
    options = params.permit(:metric, :mode, :year, :month)
    Analytics::SummaryReport.for(options)
  end
end
