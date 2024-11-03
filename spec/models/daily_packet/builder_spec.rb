require "rails_helper"

describe DailyPacket::Builder do
  describe ".find_or_build_for" do
    let(:built_on) { Date.parse("2007-07-07") }

    context "with an existing DailyPacket record" do
      it "returns that existing record" do
        existing_daily_packet = FactoryBot.create(:daily_packet, built_on: built_on)
        returned_daily_packet = DailyPacket::Builder.find_or_build_for(built_on)
        expect(returned_daily_packet.id).to eq existing_daily_packet.id
        expect(DailyPacket.count).to eq 1
      end
    end

    context "without an existing DailyPacket record" do
      it "creates and returns a new record" do
        FactoryBot.create(:warm_fuzzy)

        expect do
          DailyPacket::Builder.find_or_build_for(built_on)
        end.to change(DailyPacket, :count).from(0).to(1)
      end
    end
  end
end
