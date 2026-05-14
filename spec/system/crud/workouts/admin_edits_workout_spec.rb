require "rails_helper"

describe "Admin edits workout" do
  include_context "admin password matches"

  scenario "from show page" do
    workout = FactoryBot.create(:workout)
    visit "/crud/workouts/#{workout.id}"
    click_on "Edit Workout"
    expect(page).to have_css "h1", text: "Edit Workout #{workout.id}"
    expect(page).to have_css "a", text: "Show Workout"
    expect(page).to have_current_path edit_crud_workout_path(workout)
  end

  scenario "edit with errors" do
    workout = FactoryBot.create(:workout)
    visit "/crud/workouts/#{workout.id}/edit"
    fill_in "title", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Title can't be blank"
  end

  scenario "edit successfully" do
    workout = FactoryBot.create(
      :workout,
      title: "Warm Down"
    )
    visit "/crud/workouts/#{workout.id}/edit"
    fill_in "title", with: "Warm Up"
    click_on "update"

    expect(page).to have_css ".notice", text: "Workout updated"
    expect(page).to have_current_path crud_workout_path(workout)
    expect(page).to have_css "td", text: "Warm Up"
  end
end
