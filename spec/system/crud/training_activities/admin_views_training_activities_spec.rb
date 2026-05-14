require "rails_helper"

describe "Admin views training activities" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Training Activities"
    expect(page).to have_css "h1", text: "Training Activities"
    expect(page).to have_current_path crud_training_activities_path
  end

  scenario "with no records" do
    visit "/crud/training_activities"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    (1..3).each do |offset|
      FactoryBot.create(
        :training_activity,
        training_day: FactoryBot.create(:training_day, date: Date.today + offset.days)
      )
    end
    visit "/crud/training_activities"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    (1..4).each do |offset|
      FactoryBot.create(
        :training_activity,
        training_day: FactoryBot.create(:training_day, date: Date.today + offset.days)
      )
    end
    visit "/crud/training_activities"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
