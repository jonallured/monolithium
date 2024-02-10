class FinancialReportsController < ApplicationController
  layout "wide"
  expose(:financial_report) { FinancialReport.new(params[:year].to_i) }
end
