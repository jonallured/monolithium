require "rails_helper"

describe DailyPacket do
  describe "validation" do
    it "is not valid without required attributes" do
      daily_packet = DailyPacket.create
      expect(daily_packet).to_not be_valid
      expect(daily_packet.errors.messages).to eq({
        built_on: ["can't be blank"],
        reading_list_pace: ["can't be blank"],
        warm_fuzzy: ["must exist"]
      })
    end

    it "is valid with required attributes" do
      built_on = Date.parse("2007-07-07")
      reading_list_pace = 4.7
      warm_fuzzy = FactoryBot.create(:warm_fuzzy)
      daily_packet = DailyPacket.create(
        built_on: built_on,
        reading_list_pace: reading_list_pace,
        warm_fuzzy: warm_fuzzy
      )
      expect(daily_packet).to be_valid
    end
  end

  describe ".next_edition_number" do
    context "with no DailyPacket records" do
      it "returns 1" do
        expect(DailyPacket.next_edition_number).to eq 1
      end
    end

    context "with a DailyPacket record" do
      it "returns the edition number after that record's value" do
        FactoryBot.create(:daily_packet, edition_number: 7)
        expect(DailyPacket.next_edition_number).to eq 8
      end
    end

    context "with a few DailyPacket records" do
      it "returns the edition number after the record with the highest value" do
        FactoryBot.create(:daily_packet, edition_number: 1)
        FactoryBot.create(:daily_packet, edition_number: 7)
        FactoryBot.create(:daily_packet, edition_number: 3)

        expect(DailyPacket.next_edition_number).to eq 8
      end
    end
  end
end
