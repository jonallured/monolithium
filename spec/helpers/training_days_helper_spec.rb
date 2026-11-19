require "rails_helper"

describe TrainingDaysHelper do
  describe "#calendar_color" do
    it "returns black for filler days" do
      expect(helper.calendar_color(:filler)).to eq "bg-black"
    end

    it "returns dark gray for upcoming days" do
      expect(helper.calendar_color(:going)).to eq "bg-dark-gray"
    end

    it "returns white for missed days" do
      expect(helper.calendar_color(:missed)).to eq "bg-white"
    end

    it "returns purple for completed days" do
      expect(helper.calendar_color(:went)).to eq "bg-purple"
    end
  end

  describe "#week_color" do
    it "returns off white for upcoming days" do
      expect(helper.week_color(:going)).to eq "text-off-white"
    end

    it "returns black for missed days" do
      expect(helper.week_color(:missed)).to eq "text-black"
    end

    it "returns off white for completed days" do
      expect(helper.week_color(:went)).to eq "text-off-white"
    end

    it "returns nil for filler days" do
      expect(helper.week_color(:filler)).to be_nil
    end
  end
end
