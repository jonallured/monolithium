module Analytics
  class SummaryRow
    attr_reader :label, :count

    def initialize(label, count)
      @label = label
      @count = count
    end

    def <=>(other)
      count_order = other.count <=> count
      label_order = label <=> other.label

      count_order.zero? ? label_order : count_order
    end
  end
end
