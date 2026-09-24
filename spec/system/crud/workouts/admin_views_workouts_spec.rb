require "rails_helper"

describe "Admin views workouts" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Workouts"
    expect(page).to have_css "h1", text: "Workouts"
    expect(page).to have_current_path crud_workouts_path
  end

  scenario "with no records" do
    visit "/crud/workouts"
    headers = page.find("thead tr").text
    expect(headers).to eq "ID Title Active Created At"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a record" do
    workout = FactoryBot.create(
      :workout,
      active: true,
      title: "Warm Up"
    )
    visit "/crud/workouts"
    rows = page.all("tbody tr")
    expect(rows.count).to eq 1

    cells = rows.first.all("td").map(&:text)
    expect(cells).to eq([
      workout.id.to_s,
      "Warm Up",
      "true",
      workout.created_at.to_fs
    ])
  end

  scenario "with a record that has a long title" do
    workout = FactoryBot.create(
      :workout,
      title: "This title is so long that it would cause rendering issues and what I'd rather see is it cut off"
    )
    visit "/crud/workouts"
    title_cell = page.all("tbody td")[1].text
    expect(title_cell).to eq workout.title.truncate(20)
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:workout, 3)
    visit "/crud/workouts"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:workout, 4)
    visit "/crud/workouts"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
