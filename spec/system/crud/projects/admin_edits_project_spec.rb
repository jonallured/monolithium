require "rails_helper"

describe "Admin edits project" do
  include_context "admin password matches"

  scenario "from show page" do
    project = FactoryBot.create(:project)
    visit "/crud/projects/#{project.id}"
    click_on "Edit Project"
    expect(page).to have_css "h1", text: "Edit Project #{project.id}"
    expect(page).to have_css "a", text: "Show Project"
    expect(page).to have_current_path edit_crud_project_path(project)
  end

  scenario "edit with errors" do
    project = FactoryBot.create(:project)
    visit "/crud/projects/#{project.id}/edit"
    fill_in "name", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Name can't be blank"
  end

  scenario "edit successfully" do
    project = FactoryBot.create(
      :project,
      name: "Yet Another Rooby Gem"
    )
    visit "/crud/projects/#{project.id}/edit"
    fill_in "name", with: "Yet Another Ruby Gem"
    click_on "update"

    expect(page).to have_css ".notice", text: "Project updated"
    expect(page).to have_current_path crud_project_path(project)
    expect(page).to have_css "td", text: "Yet Another Ruby Gem"
  end
end
