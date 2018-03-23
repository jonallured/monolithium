require 'rails_helper'

feature 'User views project list', js: true do
  scenario 'with no projects' do
    visit '/projects'
    expect(page).to have_content 'No projects - create one!'
  end

  scenario 'with a few projects' do
    FactoryBot.create :project, name: 'first', touched_at: Time.now + 1.day
    FactoryBot.create :project, name: 'second', touched_at: Time.now - 1.day
    FactoryBot.create :project, name: 'third', touched_at: Time.now

    visit '/projects'

    project_names = page.all('li .name').map(&:text)
    expect(project_names).to eq %w[second third first]
  end
end
