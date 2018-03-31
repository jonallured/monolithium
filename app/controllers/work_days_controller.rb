class WorkDaysController < ApiController
  expose(:work_day) { WorkDay.find_by id: params[:id] }

  def update
    return head :not_found unless work_day

    if work_day.update(work_day_params)
      head :no_content
    else
      head :bad_request
    end
  end

  private

  def work_day_params
    params.permit(:adjust_minutes, :in_minutes, :out_minutes, :pto_minutes)
  end
end
