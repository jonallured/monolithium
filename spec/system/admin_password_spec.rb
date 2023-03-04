require "rails_helper"

describe "Admin Password" do
  scenario "signing in without redirect_to lands on dashboard" do
    visit "/sign_in"
    fill_in "admin_password", with: "shhh"
    click_on "sign in"
    expect(page).to have_content "Password saved to session"
    expect(current_path).to eq dashboard_path
  end

  scenario "signing in with redirect_to works" do
    visit "/projects"
    fill_in "admin_password", with: "shhh"
    click_on "sign in"
    expect(page).to have_content "Password saved to session"
    expect(current_path).to eq "/projects"
  end

  scenario "signing out clears session" do
    visit "/sign_in"
    fill_in "admin_password", with: "shhh"
    click_on "sign in"
    expect(page).to have_content "Password saved to session"
    visit "/sign_out"
    expect(page).to have_content "Password removed from session"
    visit "/dashboard"
    expect(current_path).to eq sign_in_path
  end
end
