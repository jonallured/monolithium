require "rails_helper"

describe "Admin views project list", js: true do
  include_context "admin password matches"

  scenario "with no projects" do
    visit "/admin/projects"
    expect(page).to have_content "No projects - create one!"
  end

  scenario "with a few projects" do
    FactoryBot.create :project, name: "1st", touched_at: 1.day.from_now
    FactoryBot.create :project, name: "2nd", touched_at: 1.day.ago
    FactoryBot.create :project, name: "3rd", touched_at: Time.zone.now

    visit "/admin/projects"

    project_names = page.all("li .name").map(&:text)
    expect(project_names).to eq %w[2nd 3rd 1st]
  end
end
