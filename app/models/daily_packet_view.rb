class DailyPacketView
  include Prawn::View

  def initialize(built_on)
    @built_on_phrase = "#{built_on.to_fs}, week #{built_on.cweek}"
    @warm_fuzzy = WarmFuzzy.random
    reading_list = ReadingList.new
    @reading_list_phrase = "#{reading_list.pace} pages/day"
    build
  end

  def pdf_data
    document.render
  end

  private

  def build
    stroke_color "000000"
    draw_front_page
    start_new_page
    draw_top_three_page
    start_new_page
    draw_chore_list_page
  end

  def draw_front_page
    text "Daily Packet", style: :bold_italic, size: 42

    move_up 34

    text @built_on_phrase, align: :right, size: 18

    stroke do
      horizontal_rule
    end

    move_down 20

    column_box([0, cursor], columns: 2, width: bounds.width) do
      text "Random Warm Fuzzy", style: :bold, size: 20

      if @warm_fuzzy
        text @warm_fuzzy.title, size: 16
        text @warm_fuzzy.body, size: 12
        text "\n- #{@warm_fuzzy.author}, #{@warm_fuzzy.received_at.to_fs}", size: 12, align: :right
      end

      move_down 20

      font_size(20) do
        text "Reading Pace", style: :bold
        text @reading_list_phrase
      end
    end
  end

  def draw_top_three_page
    text "Top Three", size: 40

    stroke do
      horizontal_rule
    end

    move_down 30

    text "Personal", size: 30

    move_down 10

    font_size(20) do
      text "1. #{"_" * 40}"
      move_down 10
      text "2. #{"_" * 40}"
      move_down 10
      text "3. #{"_" * 40}"
    end

    move_down 30

    text "Work", size: 30

    move_down 10

    font_size(20) do
      text "1. #{"_" * 40}"
      move_down 10
      text "2. #{"_" * 40}"
      move_down 10
      text "3. #{"_" * 40}"
    end
  end

  def draw_chore_list_page
    text "Chore List", size: 40

    stroke do
      horizontal_rule
    end

    move_down 30

    font_size(20) do
      text "unload dishwasher"
      text "collect laundry"
      text "defrost meat"
      text "poop patrol"
      text "mow front"
      text "mow back"
      text "mow way back"
      text "put out garbage cans"
      text "wipe off kitchen table"
      text "run dishwasher"
    end
  end
end
