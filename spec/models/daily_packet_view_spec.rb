require "rails_helper"

describe DailyPacketView do
  it "renders the document" do
    built_on = Date.new(2007, 7, 7)
    view = DailyPacketView.new(built_on)
    inspector = PDF::Inspector::Page.analyze(view.pdf_data)

    expect(inspector.pages.size).to eq 2

    page_one_strings, page_two_strings = inspector.pages.map { |page| page[:strings] }

    expect(page_one_strings).to eq([
      "Daily Packet",
      "07/07/2007, week 27",
      "Random Warm Fuzzy",
      "Reading Pace",
      "0.0 pages/day"
    ])

    expect(page_two_strings).to eq([
      "TOP THREE",
      "Personal",
      "1. #{"_" * 40}",
      "2. #{"_" * 40}",
      "3. #{"_" * 40}",
      "Work",
      "1. #{"_" * 40}",
      "2. #{"_" * 40}",
      "3. #{"_" * 40}"
    ])
  end
end
