require 'rails_helper'

feature 'User views project list', js: true do
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:session_password_matches?).and_return(true)
  end

  scenario 'with no projects' do
    visit '/projects'
    expect(page).to have_content 'No projects - create one!'
  end

  scenario 'with a few projects' do
    FactoryBot.create :project, name: '1st', touched_at: Time.zone.now + 1.day
    FactoryBot.create :project, name: '2nd', touched_at: Time.zone.now - 1.day
    FactoryBot.create :project, name: '3rd', touched_at: Time.zone.now

    visit '/projects'

    project_names = page.all('li .name').map(&:text)
    expect(project_names).to eq %w[2nd 3rd 1st]
  end
end
