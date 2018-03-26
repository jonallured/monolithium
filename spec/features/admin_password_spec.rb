require 'rails_helper'

feature 'Admin Password' do
  scenario 'signing in without redirect_to lands on home page' do
    visit '/sign_in'
    fill_in 'admin_password', with: 'shhh'
    click_on 'Sign In'
    expect(page).to have_content 'Password saved to session'
    expect(current_path).to eq root_path
  end

  scenario 'signing in with redirect_to works' do
    visit '/projects'
    fill_in 'admin_password', with: 'shhh'
    click_on 'Sign In'
    expect(current_path).to eq '/projects'
  end

  scenario 'signing out clears session' do
    visit '/sign_in'
    fill_in 'admin_password', with: 'shhh'
    click_on 'Sign In'
    visit '/projects'
    expect(current_path).to eq '/projects'
    visit 'sign_out'
    expect(page).to have_content 'Password removed from session'
    visit '/projects'
    expect(current_path).to eq sign_in_path
  end
end
