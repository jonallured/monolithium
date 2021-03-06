require 'rails_helper'

describe 'User updates project', js: true do
  context 'signed in as admin' do
    include_context 'session password matches'

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
end
