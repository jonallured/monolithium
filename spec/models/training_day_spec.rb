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

  describe ".current_streak" do
    context "with no records" do
      it "returns 0" do
        streak = TrainingDay.current_streak
        expect(streak).to eq 0
      end
    end

    context "with a rest day record" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: Date.today, intensity: "rest", completed_at: Date.today)
        streak = TrainingDay.current_streak
        expect(streak).to eq 0
      end
    end

    context "with a record from 2 days ago" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: 2.days.ago, intensity: "lift", completed_at: 2.days.ago)
        streak = TrainingDay.current_streak
        expect(streak).to eq 0
      end
    end

    context "with a record from tomorrow" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: Date.tomorrow, intensity: "lift")
        streak = TrainingDay.current_streak
        expect(streak).to eq 0
      end
    end

    context "with a record that is not completed" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: Date.today, intensity: "lift", completed_at: nil)
        streak = TrainingDay.current_streak
        expect(streak).to eq 0
      end
    end

    context "with a completed record from yesterday" do
      it "returns 1" do
        FactoryBot.create(:training_day, date: Date.yesterday, intensity: "lift", completed_at: Date.yesterday)
        streak = TrainingDay.current_streak
        expect(streak).to eq 1
      end
    end

    context "with a completed record from yesterday and today" do
      it "returns 2" do
        FactoryBot.create(:training_day, date: Date.yesterday, intensity: "lift", completed_at: Date.yesterday)
        FactoryBot.create(:training_day, date: Date.today, intensity: "recovery", completed_at: Date.today)
        streak = TrainingDay.current_streak
        expect(streak).to eq 2
      end
    end
  end

  describe ".longest_streak" do
    context "with no records" do
      it "returns 0" do
        streak = TrainingDay.longest_streak
        expect(streak).to eq 0
      end
    end

    context "with a rest day record" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: Date.today, intensity: "rest", completed_at: Date.today)
        streak = TrainingDay.longest_streak
        expect(streak).to eq 0
      end
    end

    context "with a record from tomorrow" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: Date.tomorrow, intensity: "lift")
        streak = TrainingDay.longest_streak
        expect(streak).to eq 0
      end
    end

    context "with a record that is not completed" do
      it "returns 0" do
        FactoryBot.create(:training_day, date: Date.today, intensity: "lift", completed_at: nil)
        streak = TrainingDay.longest_streak
        expect(streak).to eq 0
      end
    end

    context "with a completed record" do
      it "returns 1" do
        FactoryBot.create(:training_day, date: Date.today, intensity: "lift", completed_at: Date.today)
        streak = TrainingDay.longest_streak
        expect(streak).to eq 1
      end
    end

    context "with a few completed records and a rest day in the middle" do
      it "returns 2" do
        FactoryBot.create(:training_day, date: 3.day.ago, intensity: "recovery", completed_at: 3.days.ago)
        FactoryBot.create(:training_day, date: 2.day.ago, intensity: "lift", completed_at: 2.days.ago)
        FactoryBot.create(:training_day, date: 1.day.ago, intensity: "rest", completed_at: 1.days.ago)
        FactoryBot.create(:training_day, date: Date.today, intensity: "lift", completed_at: Date.today)
        streak = TrainingDay.longest_streak
        expect(streak).to eq 2
      end
    end
  end
end
