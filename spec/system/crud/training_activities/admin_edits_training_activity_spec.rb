require "rails_helper"

describe "Admin edits training activity" do
  include_context "admin password matches"

  scenario "from show page" do
    training_activity = FactoryBot.create(:training_activity)
    visit "/crud/training_activities/#{training_activity.id}"
    click_on "Edit Training Activity"
    expect(page).to have_css "h1", text: "Edit Training Activity #{training_activity.id}"
    expect(page).to have_css "a", text: "Show Training Activity"
    expect(page).to have_current_path edit_crud_training_activity_path(training_activity)
  end

  scenario "edit with errors" do
    training_activity = FactoryBot.create(:training_activity)
    visit "/crud/training_activities/#{training_activity.id}/edit"
    fill_in "training_day_id", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Training day must exist"
  end

  scenario "edit successfully" do
    initial_training_day = FactoryBot.create(:training_day, date: Date.today)
    updated_training_day = FactoryBot.create(:training_day, date: Date.yesterday)

    training_activity = FactoryBot.create(
      :training_activity,
      training_day: initial_training_day,
      workout: FactoryBot.create(:workout)
    )
    visit "/crud/training_activities/#{training_activity.id}/edit"
    fill_in "training_day_id", with: updated_training_day.id
    click_on "update"

    expect(page).to have_css ".notice", text: "Training Activity updated"
    expect(page).to have_current_path crud_training_activity_path(training_activity)
    expect(page).to have_css "td", text: updated_training_day.id.to_s
  end
end
