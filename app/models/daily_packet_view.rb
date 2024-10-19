class DailyPacketView
  include Prawn::View

  def initialize(built_on)
    @built_on = built_on
    @warm_fuzzy = WarmFuzzy.random
    @reading_list = ReadingList.new
    build
  end

  private

  def build
    stroke_color "000000"

    define_grid(columns: 6, rows: 12, gutter: 12)

    grid([0, 0], [0, 2]).bounding_box do
      text "Daily Packet", style: :bold_italic, size: 42, valign: :center
    end

    grid([0, 3], [0, 5]).bounding_box do
      text "#{@built_on.to_fs}, week #{@built_on.cweek}", align: :right, size: 18, valign: :center
    end

    stroke do
      horizontal_rule
    end

    grid([1, 0], [2, 2]).bounding_box do
      font_size(20) do
        text "Random Warm Fuzzy", style: :bold

        if @warm_fuzzy
          text @warm_fuzzy.title
          text @warm_fuzzy.body
          text @warm_fuzzy.author
          text @warm_fuzzy.received_at.to_fs
        end
      end
    end

    grid([1, 3], [1, 5]).bounding_box do
      font_size(20) do
        text "Reading Pace", style: :bold
        text "#{@reading_list.pace} pages/day"
      end
    end
  end
end
