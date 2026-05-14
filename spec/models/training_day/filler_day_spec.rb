require "rails_helper"

describe TrainingDay::FillerDay do
  describe ".fill_after" do
    context "with a date that is not the end of the month" do
      it "returns an empty array" do
        date = Date.new(2026, 5, 4)
        filler_days = TrainingDay::FillerDay.fill_after(date)
        expect(filler_days).to eq([])
      end
    end

    context "with a date that is the end of the month" do
      it "returns filled days" do
        date = Date.new(2026, 5, 31)
        filler_days = TrainingDay::FillerDay.fill_after(date)
        dates = filler_days.map(&:date).map(&:to_fs)
        expect(dates).to eq([
          "06/01/2026",
          "06/02/2026",
          "06/03/2026",
          "06/04/2026",
          "06/05/2026",
          "06/06/2026"
        ])
      end
    end

    context "with a date that is the end of the month but needs no filler" do
      it "returns an empty array" do
        date = Date.new(2026, 2, 28)
        filler_days = TrainingDay::FillerDay.fill_after(date)
        expect(filler_days).to eq([])
      end
    end
  end

  describe ".fill_before" do
    context "with a date that is not the beginning of the month" do
      it "returns an empty array" do
        date = Date.new(2026, 5, 4)
        filler_days = TrainingDay::FillerDay.fill_before(date)
        expect(filler_days).to eq([])
      end
    end

    context "with a date that is the beginning of the month" do
      it "returns filled days" do
        date = Date.new(2026, 5, 1)
        filler_days = TrainingDay::FillerDay.fill_before(date)
        dates = filler_days.map(&:date).map(&:to_fs)
        expect(dates).to eq([
          "04/26/2026",
          "04/27/2026",
          "04/28/2026",
          "04/29/2026",
          "04/30/2026"
        ])
      end
    end

    context "with a date that is the beginning of the month but needs no filler" do
      it "returns an empty array" do
        date = Date.new(2026, 2, 1)
        filler_days = TrainingDay::FillerDay.fill_after(date)
        expect(filler_days).to eq([])
      end
    end
  end
end
