require "rails_helper"

describe TrainingDay do
  describe "validation" do
    context "without required attributes" do
      it "is not valid" do
        training_day = TrainingDay.create
        expect(training_day).to_not be_valid
      end
    end

    context "with required attributes" do
      it "is valid" do
        training_day = TrainingDay.create(
          date: Date.new,
          intensity: "lift",
          with_coach: false
        )
        expect(training_day).to be_valid
      end
    end

    context "with invalid intensity" do
      it "is not valid" do
        training_day = TrainingDay.create(
          date: Date.new,
          intensity: "invalid",
          with_coach: false
        )
        expect(training_day).to_not be_valid
      end
    end
  end
end
