module Analytics
  class SummaryReport < BaseReport
    def calculate
      @matching_items = ApacheLogItem.where(requested_at: @period_start.all_month)
      report_field = METRIC_TO_FIELD_MAP[@metric_name]
      grouped_items = @matching_items.group(report_field).count
      summary_rows = grouped_items.map { |label, count| SummaryRow.new(label, count) }
      @rows = summary_rows.sort
    end

    def to_partial_path
      "summary"
    end
  end
end
