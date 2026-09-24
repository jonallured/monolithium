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

  describe ".active" do
    context "with no active workouts" do
      it "returns an empty array" do
        active_workouts = Workout.active
        expect(active_workouts).to eq([])
      end
    end

    context "with an inactive workout" do
      it "returns an empty array" do
        FactoryBot.create(:workout, active: false)
        active_workouts = Workout.active
        expect(active_workouts).to eq([])
      end
    end

    context "with an active workout" do
      it "returns that workout" do
        active_workout = FactoryBot.create(:workout, active: true)
        active_workouts = Workout.active
        expect(active_workouts).to eq([active_workout])
      end
    end
  end
end
