module Analytics
  class DetailRow
    attr_reader :label, :requested_at

    def initialize(label, requested_at)
      @label = label
      @requested_at = requested_at
    end
  end
end
