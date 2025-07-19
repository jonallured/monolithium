module Api
  module V1
    class WorkDaysController < Api::V1Controller
      before_action :ensure_work_week_params, only: :index

      expose(:work_day, with: :random_or_find)

      expose(:work_days) do
        work_week = WorkWeek.find_or_create(params[:year], params[:number])
        work_week.work_days
      end

      private

      def ensure_work_week_params
        error = nil
        error = "year is required" if params[:year].nil?
        error = "number is required" if params[:number].nil?
        return if error.nil?

        render json: {error: error}, status: :bad_request
      end
    end
  end
end
