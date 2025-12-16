module Analytics
  class SummaryReport
    def self.for(options)
      report = new(options)
      report.calculate
      report
    end

    attr_reader :matching_items, :period_start, :rows

    def initialize(options)
      @period_start = Date.new(
        options[:year].to_i,
        options[:month].to_i
      )
    end

    def calculate
      @matching_items = ApacheLogItem.where(requested_at: @period_start.all_month)
      grouped_items = @matching_items.group(:request_path).count
      summary_rows = grouped_items.map { |label, count| SummaryRow.new(label, count) }
      @rows = summary_rows.sort
    end

    def prev_params
      prev_start = @period_start - 1.month
      params_for(prev_start)
    end

    def next_params
      next_start = @period_start + 1.month
      params_for(next_start)
    end

    private

    def params_for(start)
      month, year = start.strftime("%m %Y").split
      {month: month, year: year}
    end
  end
end
