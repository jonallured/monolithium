require "rails_helper"

describe "User creates new project", js: true do
  context "signed in as admin" do
    include_context "session password matches"

    scenario "creating first project" do
      visit "/projects"
      click_on "Create Project"
      fill_in "project_name", with: "First Project"
      click_on "Create"

      expect(page).to_not have_content "No projects - create one!"
      project_name = page.find("li .name").text
      expect(project_name).to eq "First Project"
    end

    scenario "error on duplicate projects" do
      project = FactoryBot.create :project

      visit "/projects"
      click_on "Create Project"
      fill_in "project_name", with: project.name
      click_on "Create"

      expect(page).to have_content "Something went wrong - project not created!"
      expect(page.all("li .name").count).to eq 1
    end
  end
end
