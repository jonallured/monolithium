require "rails_helper"

describe "Admin deletes project" do
  include_context "admin password matches"

  let(:project) { FactoryBot.create(:project) }

  scenario "cancels delete", js: true do
    visit "/crud/projects/#{project.id}"

    dismiss_confirm { click_on "Delete Project" }

    expect(Project.count).to eq 1
    expect(page).to have_current_path crud_project_path(project)
  end

  scenario "confirms delete", js: true do
    visit "/crud/projects/#{project.id}"

    accept_confirm { click_on "Delete Project" }

    expect(page).to have_css ".notice", text: "Project deleted"

    expect(Project.count).to eq 0
    expect(page).to have_current_path crud_projects_path
  end
end
