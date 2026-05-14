require "rails_helper"

describe "Admin views workout" do
  include_context "admin password matches"

  scenario "from list page" do
    workout = FactoryBot.create(:workout)
    visit "/crud/workouts"
    click_on workout.id.to_s
    expect(page).to have_css "h1", text: "Workout #{workout.id}"
    expect(page).to have_css "a", text: "Workout List"
    expect(page).to have_current_path crud_workout_path(workout)
  end

  scenario "viewing a record" do
    workout = FactoryBot.create(
      :workout,
      title: "Warm Up"
    )

    visit "/crud/workouts/#{workout.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "Warm Up"],
        ["Created At", workout.created_at.to_fs],
        ["Updated At", workout.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    workout = FactoryBot.create(:workout)
    expect(Workout).to receive(:random).and_return(workout)

    visit "/crud/workouts"
    click_on "Random Workout"

    expect(page).to have_css "h1", text: "Workout #{workout.id}"
    expect(page).to have_current_path crud_workout_path(workout)
  end
end
