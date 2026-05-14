require "rails_helper"

describe Workout do
  describe "validation" do
    context "without required attributes" do
      it "is not valid" do
        workout = Workout.create
        expect(workout).to_not be_valid
      end
    end

    context "with required attributes" do
      it "is valid" do
        workout = Workout.create(
          title: "Warm Up"
        )
        expect(workout).to be_valid
      end
    end
  end
end
