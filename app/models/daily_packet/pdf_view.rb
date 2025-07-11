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
    draw_personal_page
    unless daily_packet.built_on_weekend?
      start_new_page
      draw_work_page
    end
  end

  def draw_front_page
    text daily_packet.headline_phrase.upcase, style: :bold_italic, size: 42

    move_up 45

    text daily_packet.built_on_phrase, align: :right, size: 14

    stroke do
      horizontal_rule
    end

    move_down 20

    column_box([0, cursor], columns: 2, width: bounds.width) do
      text "Random Warm Fuzzy", style: :bold, size: 20

      warm_fuzzy = daily_packet.warm_fuzzy
      text warm_fuzzy.title.titlecase, size: 12

      if warm_fuzzy.body.present?
        text warm_fuzzy.body, size: 12
      elsif warm_fuzzy.screenshot.representable?
        image_data = warm_fuzzy.screenshot.download
        image_io = StringIO.new(image_data)
        image image_io, width: bounds.width
      end

      text "\n- #{warm_fuzzy.author}, #{warm_fuzzy.received_at.to_date.to_fs}", size: 12, align: :right

      move_down 20

      bounding_box([0, cursor], width: bounds.width, height: 40) do
        stroke_bounds
        star_count = Random.rand(20..50)
        gap_size = 6
        star_count.times do
          star_size = Random.rand(1..4)
          star_x = Random.rand(gap_size..(bounds.width - gap_size))
          star_y = Random.rand(gap_size..(bounds.height - gap_size))
          fill_rectangle [star_x, star_y], star_size, star_size
        end
      end

      move_down 20

      text "Reading Pace", style: :bold, size: 20
      text daily_packet.reading_list_phrase, size: 12

      move_down 20

      text "Feedbin Stats", style: :bold, size: 20
      text daily_packet.feedbin_unread_phrase, size: 12
      text daily_packet.feedbin_oldest_phrase, size: 12
    end
  end

  def draw_personal_page
    text "Top 3: Personal".upcase, style: :bold_italic, size: 42

    move_up 12

    stroke do
      horizontal_rule
    end

    move_down 20

    font_size(20) do
      text "1."
      move_down 10
      text "2."
      move_down 10
      text "3."
    end

    move_cursor_to bounds.top / 2

    text "Chore List".upcase, style: :bold_italic, size: 42

    move_up 12

    stroke do
      horizontal_rule
    end

    move_down 20

    daily_packet.chore_list.each do |chore|
      text chore, size: 14
    end
  end

  def draw_work_page
    text "Top 3: Work".upcase, style: :bold_italic, size: 42

    move_up 12

    stroke do
      horizontal_rule
    end

    move_down 20

    font_size(20) do
      text "1."
      move_down 10
      text "2."
      move_down 10
      text "3."
    end

    move_cursor_to (bounds.top / 3) * 2

    text "Start List".upcase, style: :bold_italic, size: 42

    move_up 12

    stroke do
      horizontal_rule
    end

    move_down 20

    daily_packet.start_list.each do |item|
      text item, size: 14
    end

    move_cursor_to bounds.top / 3

    text "Stop List".upcase, style: :bold_italic, size: 42

    move_up 12

    stroke do
      horizontal_rule
    end

    move_down 20

    daily_packet.stop_list.each do |item|
      text item, size: 14
    end
  end
end
