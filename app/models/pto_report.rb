class PtoReport
  def self.all
    days_with_pto = WorkDay.where('pto_minutes > 0').order(:date)
    grouped_days_with_pto = days_with_pto.order(:date).group_by(&:year)
    grouped_days_with_pto.map(&PtoReport.method(:new))
  end

  attr_reader :year

  def initialize((year, work_days))
    @year = year
    @work_days = work_days
  end

  def ytd_minutes
    past_work_days.map(&:pto_minutes).sum
  end

  def all_minutes
    @work_days.map(&:pto_minutes).sum
  end

  def pto_days
    @work_days.map(&PtoDay.method(:new))
  end

  private

  def past_work_days
    @work_days.select { |work_day| work_day.date <= Time.zone.today }
  end
end
