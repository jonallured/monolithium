require "rails_helper"

describe "Admin creates training activity" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/training_activities"
    click_on "New Training Activity"
    expect(page).to have_css "h1", text: "New Training Activity"
    expect(page).to have_css "a", text: "Training Activity List"
    expect(page).to have_current_path new_crud_training_activity_path
  end

  scenario "create with errors" do
    visit "/crud/training_activities/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Training day must exist and Workout must exist"
    expect(page).to have_current_path new_crud_training_activity_path
  end

  scenario "create successfully" do
    training_day = FactoryBot.create(:training_day)
    workout = FactoryBot.create(:workout)
    visit "/crud/training_activities/new"
    fill_in "training_day_id", with: training_day.id
    fill_in "workout_id", with: workout.id
    click_on "create"

    expect(page).to have_css ".notice", text: "Training Activity created"

    training_activity = TrainingActivity.last
    expect(page).to have_current_path crud_training_activity_path(training_activity)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Training Day ID", training_day.id.to_s],
        ["Workout ID", workout.id.to_s],
        ["Created At", training_activity.created_at.to_fs],
        ["Updated At", training_activity.updated_at.to_fs]
      ]
    )
  end
end
