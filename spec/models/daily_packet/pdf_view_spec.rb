require "rails_helper"

describe DailyPacket::PdfView do
  let(:warm_fuzzy) { FactoryBot.create(:warm_fuzzy, received_at: Time.at(0)) }
  let(:daily_packet) { FactoryBot.create(:daily_packet, built_on: built_on, warm_fuzzy: warm_fuzzy) }

  context "on a Tuesday" do
    let(:built_on) { Date.parse("2024-11-05") }

    it "renders the document" do
      inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

      expect(inspector.pages.size).to eq 3

      page_one_strings, page_two_strings, page_three_strings = inspector.pages.map { |page| page[:strings] }

      expect(page_one_strings).to eq([
        "Daily Packet ##{daily_packet.id}",
        "11/05/2024",
        "week 45",
        "Random Warm Fuzzy",
        "Alright Haircut",
        "Your haircut is adequate.",
        "- Wife, 01/01/1970",
        "Reading Pace",
        "7.7 pages/day",
        "Feedbin Stats",
        "unread: 9",
        "oldest: 14 days ago"
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
        "defrost meat",
        "poop patrol",
        "mow front",
        "mow back",
        "mow way back",
        "wipe off kitchen table",
        "run dishwasher"
      ])
    end
  end

  context "on a Monday" do
    let(:built_on) { Date.parse("2024-11-04") }

    it "renders the Monday-specific chore" do
      inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

      _, _, page_three_strings = inspector.pages.map { |page| page[:strings] }

      expect(page_three_strings).to include "put out garbage cans"
    end
  end

  context "on a Saturday" do
    let(:built_on) { Date.parse("2024-11-09") }

    it "renders the Saturday-specific chore" do
      inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

      _, _, page_three_strings = inspector.pages.map { |page| page[:strings] }

      expect(page_three_strings).to include "collect laundry"
    end
  end
end
