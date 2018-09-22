module Api
  module V1
    class WorkWeeksController < Api::V1Controller
      expose(:work_week) do
        WorkWeek.find_or_create_by(year: params[:year], number: params[:number])
      end

      def show
        return head :not_found unless work_week
      end
    end
  end
end
