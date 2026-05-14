require "rails_helper"

describe TrainingActivity do
  describe "validation" do
    context "without required attributes" do
      it "is not valid" do
        training_activity = TrainingActivity.create
        expect(training_activity).to_not be_valid
      end
    end

    context "with required attributes" do
      it "is valid" do
        workout = FactoryBot.create(:workout)
        training_day = FactoryBot.create(:training_day)
        training_activity = TrainingActivity.create(
          training_day: training_day,
          workout: workout
        )
        expect(training_activity).to be_valid
      end
    end
  end
end
