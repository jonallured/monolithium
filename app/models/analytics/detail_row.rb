module Analytics
  class DetailRow
    attr_reader :id, :label, :requested_at

    def initialize(id, label, requested_at)
      @id = id
      @label = label
      @requested_at = requested_at
    end
  end
end
