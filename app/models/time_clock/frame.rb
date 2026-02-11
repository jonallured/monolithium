module TimeClock
  class Frame
    DISPLAY_TYPE_TO_ICON_MAP = {
      "beer" => 613,
      "heart" => 794,
      "monolithium" => 71783,
      "skull" => 148,
      "smile" => 4907
    }

    def self.default
      new("monolithium", "live")
    end

    attr_reader :text

    def initialize(display_type, text)
      @display_type = display_type
      @text = text
    end

    def icon
      DISPLAY_TYPE_TO_ICON_MAP[@display_type]
    end
  end
end
