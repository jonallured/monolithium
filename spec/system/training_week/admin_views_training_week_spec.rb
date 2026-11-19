require "rails_helper"

describe "Admin views training week" do
  include_context "admin password matches"

  let(:date) { Date.new(2026, 11, 18) }

  scenario "with a completed training day" do
    FactoryBot.create(:training_day, date: date, completed_at: date.noon)
    visit training_week_path(TrainingDay::WeekReport.params_for(date))
    expect(page).to have_css "dl.bg-purple.text-off-white dt", text: "recovery"
  end

  scenario "with a missed training day" do
    FactoryBot.create(:training_day, date: date, intensity: "rest")
    visit training_week_path(TrainingDay::WeekReport.params_for(date))
    expect(page).to have_css "dl.bg-white.text-black dt", text: "rest"
  end

  scenario "picking a workout for a training day" do
    FactoryBot.create(:training_day, date: date)
    FactoryBot.create(:workout, title: "Squat", active: true)
    FactoryBot.create(:workout, title: "Retired", active: false)
    visit training_week_path(TrainingDay::WeekReport.params_for(date))
    find("summary", text: "Wednesday").click
    expect(page).to have_select "training_day_training_activities_attributes_0_workout_id",
      options: ["please select", "Squat"]
  end
end
