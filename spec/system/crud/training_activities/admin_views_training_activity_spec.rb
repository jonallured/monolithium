require "rails_helper"

describe "Admin views training activity" do
  include_context "admin password matches"

  scenario "from list page" do
    training_activity = FactoryBot.create(:training_activity)
    visit "/crud/training_activities"
    click_on training_activity.id.to_s
    expect(page).to have_css "h1", text: "Training Activity #{training_activity.id}"
    expect(page).to have_css "a", text: "Training Activity List"
    expect(page).to have_current_path crud_training_activity_path(training_activity)
  end

  scenario "viewing a record" do
    training_day = FactoryBot.create(:training_day)
    workout = FactoryBot.create(:workout)
    training_activity = FactoryBot.create(
      :training_activity,
      training_day: training_day,
      workout: workout
    )

    visit "/crud/training_activities/#{training_activity.id}"

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

  scenario "views random record" do
    training_activity = FactoryBot.create(:training_activity)
    expect(TrainingActivity).to receive(:random).and_return(training_activity)

    visit "/crud/training_activities"
    click_on "Random Training Activity"

    expect(page).to have_css "h1", text: "Training Activity #{training_activity.id}"
    expect(page).to have_current_path crud_training_activity_path(training_activity)
  end
end
