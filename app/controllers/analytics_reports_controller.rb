class AnalyticsReportsController < ApplicationController
  expose(:analytics_report) do
    options = params.permit(:metric, :mode, :year, :month)
    if options[:mode] == "detail"
      options[:page] = params[:page]
      Analytics::DetailReport.for(options)
    else
      Analytics::SummaryReport.for(options)
    end
  end
end
