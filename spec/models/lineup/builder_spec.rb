require "rails_helper"

describe Lineup::Builder do
  describe ".ensure_current" do
    context "when there is a current Lineup" do
      let(:current_on) { Date.current }

      it "creates a Lineup for tomorrow" do
        FactoryBot.create(:lineup, current_on: current_on)
        expect(Lineup.current).to_not be_nil
        expect do
          Lineup::Builder.ensure_current
        end.to change(Lineup, :count).from(1).to(2)
      end
    end

    context "when there is a Lineup from yesterday" do
      let(:current_on) { Date.current - 1.day }

      it "creates a Lineup for today and tomorrow" do
        FactoryBot.create(:lineup, current_on: current_on)
        expect(Lineup.current).to be_nil
        expect do
          Lineup::Builder.ensure_current
        end.to change(Lineup, :count).from(1).to(3)
        expect(Lineup.current).to_not be_nil
      end
    end

    context "when there is a gap in Lineup records" do
      let(:current_on) { Date.current - 7.days }

      it "creates enough Lineup records to catch up" do
        FactoryBot.create(:lineup, current_on: current_on)
        expect(Lineup.current).to be_nil
        expect do
          Lineup::Builder.ensure_current
        end.to change(Lineup, :count).from(1).to(9)
        expect(Lineup.current).to_not be_nil
      end
    end
  end
end
