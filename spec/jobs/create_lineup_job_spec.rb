require "rails_helper"

describe CreateLineupJob do
  context "when there is a Lineup from yesterday" do
    let(:current_on) { Date.yesterday }

    it "creates a Lineup for today" do
      FactoryBot.create(:lineup, current_on: current_on)
      expect(Lineup.current).to be_nil
      expect do
        CreateLineupJob.new.perform
      end.to change(Lineup, :count).from(1).to(2)
      expect(Lineup.current).to_not be_nil
    end
  end

  context "when there is a gap in Lineup records" do
    let(:current_on) { Date.today - 7.days }

    it "creates enough Lineup records to catch up" do
      FactoryBot.create(:lineup, current_on: current_on)
      expect(Lineup.current).to be_nil
      expect do
        CreateLineupJob.new.perform
      end.to change(Lineup, :count).from(1).to(8)
      expect(Lineup.current).to_not be_nil
    end
  end
end
