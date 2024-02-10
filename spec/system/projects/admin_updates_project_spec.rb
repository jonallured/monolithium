require "rails_helper"

describe "Admin updates project", js: true do
  include_context "admin password matches"

  scenario "project is updated" do
    FactoryBot.create :project, name: "Older"
    project = FactoryBot.create :project
    FactoryBot.create :project, name: "Newer"

    visit "/admin/projects"
    project_item = page.find("li", text: project.name)
    project_item.click

    touched_projects = page.all(".touched")
    expect(touched_projects.count).to eq 1
  end
end
