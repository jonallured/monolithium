class DailyPacket::PdfView < ActiveRecord::AssociatedObject
  include Prawn::View

  def initialize(daily_packet)
    super
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

    text daily_packet.built_on_phrase, align: :right, size: 18

    stroke do
      horizontal_rule
    end

    move_down 20

    column_box([0, cursor], columns: 2, width: bounds.width) do
      text "Random Warm Fuzzy", style: :bold, size: 20

      warm_fuzzy = daily_packet.warm_fuzzy
      text warm_fuzzy.title, size: 16
      text warm_fuzzy.body, size: 12
      text "\n- #{warm_fuzzy.author}, #{warm_fuzzy.received_at.to_fs}", size: 12, align: :right

      move_down 20

      text "Reading Pace", style: :bold, size: 20
      text daily_packet.reading_list_phrase, size: 16

      move_down 20

      text "Feedbin Stats", style: :bold, size: 20
      text daily_packet.feedbin_unread_phrase, size: 16
      text daily_packet.feedbin_oldest_phrase, size: 16
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
