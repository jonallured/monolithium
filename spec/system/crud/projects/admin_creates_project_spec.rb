require "rails_helper"

describe "Admin creates project" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/projects"
    click_on "New Project"
    expect(page).to have_css "h1", text: "New Project"
    expect(page).to have_css "a", text: "Project List"
    expect(page).to have_current_path new_crud_project_path
  end

  scenario "create with errors" do
    visit "/crud/projects/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Name can't be blank"
    expect(page).to have_current_path new_crud_project_path
  end

  scenario "create successfully" do
    visit "/crud/projects/new"
    fill_in "name", with: "Yet Another Ruby Gem"
    click_on "create"

    expect(page).to have_css ".notice", text: "Project created"

    project = Project.last
    expect(page).to have_current_path crud_project_path(project)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Yet Another Ruby Gem"],
        ["Touched At", ""],
        ["Created At", project.created_at.to_formatted_s(:long)],
        ["Updated At", project.updated_at.to_formatted_s(:long)]
      ]
    )
  end
end
