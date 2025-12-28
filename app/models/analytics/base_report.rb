module Analytics
  class BaseReport
    METRIC_TO_FIELD_MAP = {
      "browser" => :browser_name,
      "page" => :request_path,
      "referrer" => :referrer_host
    }

    def self.for(options)
      report = new(options)
      report.calculate
      report
    end

    attr_reader :matching_items, :metric_name, :period_start, :rows

    def initialize(options)
      @metric_name = options[:metric].singularize

      @period_start = Date.new(
        options[:year].to_i,
        options[:month].to_i
      )
    end

    def calculate
      raise NotImplementedError
    end

    def prev_params
      prev_start = @period_start - 1.month
      params_for(prev_start)
    end

    def next_params
      next_start = @period_start + 1.month
      params_for(next_start)
    end

    def to_partial_path
      raise NotImplementedError
    end

    private

    def params_for(start)
      month, year = start.strftime("%m %Y").split
      {month: month, year: year}
    end
  end
end
