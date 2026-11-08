class IndexQuery
  class InvalidParam < StandardError; end

  DATE_FORMAT = /\A(\d{4})(?:-(\d{2})(?:-(\d{2}))?)?\z/
  ID_FORMAT = /\A[1-9]\d*\z/
  MAX_PER_PAGE = 100
  RESERVED_PARAMS = ["page", "per_page", "sort", ApiController::CLIENT_TOKEN_PARAM.to_s]

  attr_reader :model, :params

  def initialize(model, params)
    @model = model
    @params = params.to_h.stringify_keys
  end

  def records
    @records ||= build_records
  end

  private

  def build_records
    ensure_known_params

    model
      .where(filter_conditions)
      .order(sort_order)
      .page(page)
      .per(per_page)
  end

  def ensure_known_params
    allowed = RESERVED_PARAMS + model.index_filters.keys.map(&:to_s)
    unknown = params.keys - allowed
    return if unknown.empty?

    raise InvalidParam, "unsupported params: #{unknown.join(", ")}"
  end

  def filter_conditions
    model.index_filters.each_with_object({}) do |(name, kind), conditions|
      value = params[name.to_s]
      next if value.nil?

      conditions[name] = filter_value(name, kind, value)
    end
  end

  def filter_value(name, kind, value)
    case kind
    when :date
      date_value(name, value)
    when :id
      raise InvalidParam, "#{name} must be a positive integer" unless matches?(value, ID_FORMAT)

      value.to_i
    when Array
      raise InvalidParam, "#{name} must be one of: #{kind.join(", ")}" unless kind.include?(value)

      value
    else
      raise ArgumentError, "unknown filter kind for #{name}: #{kind.inspect}"
    end
  end

  def date_value(name, value)
    raise InvalidParam, "#{name} must be YYYY, YYYY-MM or YYYY-MM-DD" unless matches?(value, DATE_FORMAT)

    year, month, day = value.match(DATE_FORMAT).captures
    date = Date.new(year.to_i, (month || 1).to_i, (day || 1).to_i)

    if day
      date
    elsif month
      date.all_month
    else
      date.all_year
    end
  rescue Date::Error
    raise InvalidParam, "#{name} must be a real date"
  end

  def sort_order
    value = params.fetch("sort", model.default_index_sort)
    raise InvalidParam, "sort can't be blank" unless value.is_a?(String) && value.present?

    order = value.split(",").to_h do |field|
      name = field.delete_prefix("-")
      unless model.index_sorts.include?(name)
        raise InvalidParam, "sort must use: #{model.index_sorts.join(", ")}"
      end

      [name.to_sym, field.start_with?("-") ? :desc : :asc]
    end
    order[:id] ||= order.values.last

    order
  end

  def page
    positive_integer("page")
  end

  def per_page
    value = positive_integer("per_page")
    raise InvalidParam, "per_page must be at most #{MAX_PER_PAGE}" if value && value > MAX_PER_PAGE

    value
  end

  def positive_integer(name)
    value = params[name]
    return if value.nil?
    raise InvalidParam, "#{name} must be a positive integer" unless matches?(value, ID_FORMAT)

    value.to_i
  end

  def matches?(value, format)
    value.is_a?(String) && value.match?(format)
  end
end
