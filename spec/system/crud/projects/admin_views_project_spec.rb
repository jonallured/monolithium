require "rails_helper"

describe "Admin views project" do
  include_context "admin password matches"

  scenario "from list page" do
    project = FactoryBot.create(:project)
    visit "/crud/projects"
    click_on project.id.to_s
    expect(page).to have_css "h1", text: "Project #{project.id}"
    expect(page).to have_css "a", text: "Project List"
    expect(page).to have_current_path crud_project_path(project)
  end

  scenario "viewing a record" do
    project = FactoryBot.create(
      :project,
      name: "Yet Another Ruby Gem",
      touched_at: Time.now
    )

    visit "/crud/projects/#{project.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Yet Another Ruby Gem"],
        ["Touched At", project.touched_at.to_fs],
        ["Created At", project.created_at.to_fs],
        ["Updated At", project.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    project = FactoryBot.create(:project)
    expect(Project).to receive(:random).and_return(project)

    visit "/crud/projects"
    click_on "Random Project"

    expect(page).to have_css "h1", text: "Project #{project.id}"
    expect(page).to have_current_path crud_project_path(project)
  end
end
