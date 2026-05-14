require "rails_helper"

describe "Admin edits training day" do
  include_context "admin password matches"

  scenario "from show page" do
    training_day = FactoryBot.create(:training_day)
    visit "/crud/training_days/#{training_day.id}"
    click_on "Edit Training Day"
    expect(page).to have_css "h1", text: "Edit Training Day #{training_day.id}"
    expect(page).to have_css "a", text: "Show Training Day"
    expect(page).to have_current_path edit_crud_training_day_path(training_day)
  end

  scenario "edit with errors" do
    training_day = FactoryBot.create(:training_day)
    visit "/crud/training_days/#{training_day.id}/edit"
    select "please select", from: "training_day_intensity"
    click_on "update"
    expect(page).to have_css ".alert", text: "Intensity can't be blank and Intensity is not included in the list"
  end

  scenario "edit successfully" do
    training_day = FactoryBot.create(
      :training_day,
      intensity: "rest"
    )
    visit "/crud/training_days/#{training_day.id}/edit"
    select "lift", from: "training_day_intensity"
    click_on "update"

    expect(page).to have_css ".notice", text: "Training Day updated"
    expect(page).to have_current_path crud_training_day_path(training_day)
    expect(page).to have_css "td", text: "lift"
  end
end
