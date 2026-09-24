require "rails_helper"

describe "Admin creates workout" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/workouts"
    click_on "New Workout"
    expect(page).to have_css "h1", text: "New Workout"
    expect(page).to have_css "a", text: "Workout List"
    expect(page).to have_current_path new_crud_workout_path
  end

  scenario "create with errors" do
    visit "/crud/workouts/new"
    select "please select", from: "workout_active"
    click_on "create"
    expect(page).to have_css ".alert", text: "Title can't be blank and Active is not included in the list"
    expect(page).to have_current_path new_crud_workout_path
  end

  scenario "create successfully" do
    visit "/crud/workouts/new"
    fill_in "title", with: "Warm Up"
    select "true", from: "workout_active"
    click_on "create"

    expect(page).to have_css ".notice", text: "Workout created"

    workout = Workout.last
    expect(page).to have_current_path crud_workout_path(workout)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "Warm Up"],
        ["Active", "true"],
        ["Created At", workout.created_at.to_fs],
        ["Updated At", workout.updated_at.to_fs]
      ]
    )
  end
end
