require "rails_helper"

describe DailyPacket::PdfView do
  let(:warm_fuzzy) { FactoryBot.create(:warm_fuzzy, received_at: Time.at(0)) }
  let(:daily_packet) { FactoryBot.create(:daily_packet, built_on: built_on, warm_fuzzy: warm_fuzzy) }

  describe "full packet" do
    context "on a Tuesday" do
      let(:built_on) { Date.parse("2024-11-05") }

      it "renders the document" do
        inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

        expect(inspector.pages.size).to eq 4

        page_one_strings,
          page_two_strings,
          page_three_strings,
          page_four_strings = inspector.pages.map { |page| page[:strings] }

        expect(page_one_strings).to eq([
          "DAILY PACKET #19",
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
          "TOP 3: PERSONAL",
          "1.",
          "2.",
          "3.",
          "TOP 3: WORK",
          "1.",
          "2.",
          "3."
        ])

        expect(page_three_strings).to eq([
          "START LIST",
          "drill master password",
          "open dashboards",
          "say hi in Slack",
          "STOP LIST",
          "plug in mouse",
          "say bye in Slack"
        ])

        expect(page_four_strings).to eq([
          "CHORE LIST",
          "unload dishwasher",
          "defrost meat",
          "wipe off kitchen table",
          "run dishwasher"
        ])
      end
    end
  end

  describe "top three page" do
    context "on a Saturday" do
      let(:built_on) { Date.parse("2024-11-09") }

      it "does not render the work top three section" do
        inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

        page_two_strings = inspector.pages[1][:strings]

        expect(page_two_strings).to_not include "TOP 3: WORK"
      end
    end
  end

  describe "chore list page" do
    context "on a Monday" do
      let(:built_on) { Date.parse("2024-11-04") }

      it "renders the Monday-specific chore" do
        inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

        page_five_strings = inspector.pages.last[:strings]

        expect(page_five_strings).to include "put out garbage cans"
      end
    end

    context "on a Saturday in the fall" do
      let(:built_on) { Date.parse("2024-11-09") }

      it "renders the Weekend-specific chore but not the summertime ones" do
        inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

        page_five_strings = inspector.pages.last[:strings]

        expect(page_five_strings).to include "collect laundry"

        expect(page_five_strings).to_not include(
          "poop patrol",
          "mow front",
          "mow back",
          "mow way back"
        )
      end
    end

    context "on a Saturday in the summer" do
      let(:built_on) { Date.parse("2024-07-13") }

      it "renders the summertime Weekend-specific chores" do
        inspector = PDF::Inspector::Page.analyze(daily_packet.pdf_data)

        page_five_strings = inspector.pages.last[:strings]

        expect(page_five_strings).to include(
          "poop patrol",
          "mow front",
          "mow back",
          "mow way back"
        )
      end
    end
  end
end
