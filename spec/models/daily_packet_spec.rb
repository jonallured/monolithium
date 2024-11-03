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
end
