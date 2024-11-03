require "rails_helper"

describe DailyPacketPdfView do
  it "renders the document" do
    built_on = Date.new(2007, 7, 7)
    daily_packet = DailyPacket.create(built_on: built_on)
    view = DailyPacketPdfView.new(daily_packet)
    inspector = PDF::Inspector::Page.analyze(view.pdf_data)

    expect(inspector.pages.size).to eq 3

    page_one_strings, page_two_strings, page_three_strings = inspector.pages.map { |page| page[:strings] }

    expect(page_one_strings).to eq([
      "Daily Packet",
      "07/07/2007, week 27",
      "Random Warm Fuzzy",
      "Reading Pace",
      "0.0 pages/day"
    ])

    expect(page_two_strings).to eq([
      "Top Three",
      "Personal",
      "1. #{"_" * 40}",
      "2. #{"_" * 40}",
      "3. #{"_" * 40}",
      "Work",
      "1. #{"_" * 40}",
      "2. #{"_" * 40}",
      "3. #{"_" * 40}"
    ])

    expect(page_three_strings).to eq([
      "Chore List",
      "unload dishwasher",
      "collect laundry",
      "defrost meat",
      "poop patrol",
      "mow front",
      "mow back",
      "mow way back",
      "put out garbage cans",
      "wipe off kitchen table",
      "run dishwasher"
    ])
  end
end
