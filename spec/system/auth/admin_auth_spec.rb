require "rails_helper"

describe "Authentication" do
  scenario "signing in without redirect_to lands on dashboard" do
    visit "/sign_in"
    fill_in "admin_password", with: "shhh"
    click_on "sign in"
    expect(page).to have_content "Password saved to session"
    expect(page).to have_current_path dashboard_path
  end

  scenario "signing in with redirect_to works" do
    visit "/crud/projects"
    fill_in "admin_password", with: "shhh"
    click_on "sign in"
    expect(page).to have_content "Password saved to session"
    expect(page).to have_current_path crud_projects_path
  end

  scenario "signing out clears session" do
    visit "/sign_in"
    fill_in "admin_password", with: "shhh"
    click_on "sign in"
    expect(page).to have_content "Password saved to session"
    visit "/sign_out"
    expect(page).to have_content "Password removed from session"
    visit "/dashboard"
    expect(page).to have_current_path sign_in_path
  end
end
