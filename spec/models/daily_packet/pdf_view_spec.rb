require "rails_helper"

describe DailyPacket::PdfView do
  it "renders the document" do
    warm_fuzzy = FactoryBot.create(:warm_fuzzy, received_at: Time.at(0))
    daily_packet = FactoryBot.create(:daily_packet, warm_fuzzy: warm_fuzzy)
    view = DailyPacket::PdfView.new(daily_packet)
    inspector = PDF::Inspector::Page.analyze(view.pdf_data)

    expect(inspector.pages.size).to eq 3

    page_one_strings, page_two_strings, page_three_strings = inspector.pages.map { |page| page[:strings] }

    expect(page_one_strings).to eq([
      "Daily Packet",
      "07/07/2007, week 27",
      "Random Warm Fuzzy",
      "Alright Haircut",
      "Your haircut is adequate.",
      "- Wife, 01/01/1970 12:00:00am",
      "Reading Pace",
      "7.7 pages/day"
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
