module TimeClock
  class Frame
    def self.default
      new(71783, "live")
    end

    attr_reader :icon, :text

    def initialize(icon, text)
      @icon = icon
      @text = text
    end
  end
end
