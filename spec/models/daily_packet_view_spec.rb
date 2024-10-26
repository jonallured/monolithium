require "rails_helper"

describe DailyPacketView do
  it "renders the document" do
    built_on = Date.new(2007, 7, 7)
    view = DailyPacketView.new(built_on)
    inspector = PDF::Inspector::Text.analyze(view.pdf_data)
    expect(inspector.strings).to eq([
      "Daily Packet",
      "07/07/2007, week 27",
      "Random Warm Fuzzy",
      "Reading Pace",
      "0.0 pages/day"
    ])
  end
end
