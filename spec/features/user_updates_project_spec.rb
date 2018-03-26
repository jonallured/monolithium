require 'rails_helper'

feature 'User updates project', js: true do
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:session_password_matches?).and_return(true)
  end

  scenario 'project is updated' do
    FactoryBot.create :project, name: 'Older'
    project = FactoryBot.create :project
    FactoryBot.create :project, name: 'Newer'

    visit '/projects'
    project_item = page.find('li', text: project.name)
    project_item.click

    touched_projects = page.all('.touched')
    expect(touched_projects.count).to eq 1
  end
end
