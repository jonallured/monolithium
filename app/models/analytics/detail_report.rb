module Analytics
  class DetailReport < BaseReport
    attr_reader :paginated_items

    def initialize(options)
      super
      @page = options[:page] || 1
    end

    def calculate
      @matching_items = ApacheLogItem.where(requested_at: @period_start.all_month)
      @paginated_items = matching_items.order(requested_at: :asc).page(@page)
      report_field = METRIC_TO_FIELD_MAP[@metric_name]
      plucked_values = paginated_items.pluck(report_field, :requested_at)
      detail_rows = plucked_values.map { |label, requested_at| DetailRow.new(label, requested_at) }
      @rows = detail_rows
    end

    def to_partial_path
      "detail"
    end
  end
end
