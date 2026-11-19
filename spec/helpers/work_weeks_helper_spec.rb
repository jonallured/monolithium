require "rails_helper"

describe WorkWeeksHelper do
  let(:work_week) { WorkWeek.new(2026, 47) }

  describe "#last_week_path" do
    it "links to the previous work week" do
      expect(helper.last_week_path(work_week)).to eq "/work_weeks/2026-46"
    end
  end

  describe "#next_week_path" do
    it "links to the following work week" do
      expect(helper.next_week_path(work_week)).to eq "/work_weeks/2026-48"
    end
  end

  describe "#this_week_path" do
    it "links to the current work week" do
      travel_to Date.new(2026, 11, 19) do
        expect(helper.this_week_path).to eq "/work_weeks/2026-47"
      end
    end
  end

  context "across a year boundary" do
    let(:work_week) { WorkWeek.new(2026, 1) }

    it "links back into the previous year" do
      expect(helper.last_week_path(work_week)).to eq "/work_weeks/2025-52"
    end
  end
end
