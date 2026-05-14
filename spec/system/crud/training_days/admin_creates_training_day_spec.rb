require "rails_helper"

describe "Admin creates training day" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/training_days"
    click_on "New Training Day"
    expect(page).to have_css "h1", text: "New Training Day"
    expect(page).to have_css "a", text: "Training Day List"
    expect(page).to have_current_path new_crud_training_day_path
  end

  scenario "create with errors" do
    visit "/crud/training_days/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Date can't be blank, Intensity can't be blank, Intensity is not included in the list, and With coach is not included in the list"
    expect(page).to have_current_path new_crud_training_day_path
  end

  scenario "create successfully" do
    visit "/crud/training_days/new"
    fill_in "date", with: "01/01/2000"
    select "lift", from: "training_day_intensity"
    select "true", from: "training_day_with_coach"
    click_on "create"

    expect(page).to have_css ".notice", text: "Training Day created"

    training_day = TrainingDay.last
    expect(page).to have_current_path crud_training_day_path(training_day)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Date", "01/01/2000"],
        ["Intensity", "lift"],
        ["With Coach", "true"],
        ["Completed At", "NIL"],
        ["Created At", training_day.created_at.to_fs],
        ["Updated At", training_day.updated_at.to_fs]
      ]
    )
  end
end
