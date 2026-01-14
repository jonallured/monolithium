require "rails_helper"

describe DailyPacket::PdfView do
  let(:warm_fuzzy) { FactoryBot.create(:warm_fuzzy, received_at: Time.at(0), title: "alright haircut") }

  let(:daily_packet) do
    FactoryBot.create(:daily_packet, built_on: built_on, warm_fuzzy: warm_fuzzy)
  end

  include_context "pdf inspection"

  describe "full packet" do
    context "on a Monday" do
      let(:built_on) { Date.parse("2024-11-04") }

      it "renders the document" do
        expect(inspector.pages.size).to eq 3

        expect(page_one_strings).to eq([
          "DAILY PACKET #19",
          "11/04/2024",
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
          "CHORE LIST",
          "unload dishwasher",
          "defrost meat",
          "refill soap dispensers",
          "do hand wash",
          "wipe down kitchen",
          "run dishwasher"
        ])

        expect(page_three_strings).to eq([
          "TOP 3: WORK",
          "1.",
          "2.",
          "3.",
          "START LIST",
          "drill master password",
          "open dashboards",
          "review calendar",
          "say hi in Slack",
          "STOP LIST",
          "plug in mouse",
          "say bye in Slack"
        ])
      end
    end
  end

  describe "work page" do
    context "on a Saturday" do
      let(:built_on) { Date.parse("2024-11-09") }

      it "does not render the work page" do
        expect(inspector.pages.size).to eq 2
      end
    end
  end

  describe "chore list section" do
    context "on a Sunday" do
      let(:built_on) { Date.parse("2024-11-03") }

      it "renders the Sunday-specific chore" do
        expect(page_two_strings).to include "put out garbage cans"
      end
    end

    context "on a Tuesday" do
      let(:built_on) { Date.parse("2024-11-05") }

      it "renders the Tuesday-specific chore" do
        expect(page_two_strings).to include "wash dog bowls"
      end
    end

    context "on a Wednesday" do
      let(:built_on) { Date.parse("2024-11-06") }

      it "renders the Wednesday-specific chore" do
        expect(page_two_strings).to include "collect and wash towels"
      end
    end

    context "on a Saturday in the fall" do
      let(:built_on) { Date.parse("2024-11-09") }

      it "renders the Weekend-specific chore but not the summertime ones" do
        expect(page_two_strings).to include "collect laundry"

        expect(page_two_strings).to_not include(
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
        expect(page_two_strings).to include(
          "poop patrol",
          "mow front",
          "mow back",
          "mow way back"
        )
      end
    end
  end
end
