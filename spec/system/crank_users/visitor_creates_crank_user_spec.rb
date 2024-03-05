require "rails_helper"

describe "visitor creates crank user" do
  scenario "create successfully" do
    visit "/crank_users/new"
    click_on "create"
    expect(page).to have_content "Crank User created"
    crank_user = CrankUser.last
    expect(page).to have_content crank_user.code
    expect(page.current_path).to eq crank_user_path(crank_user)
  end
end
