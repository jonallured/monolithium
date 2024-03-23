require "rails_helper"

describe "visitor creates crank user" do
  scenario "create successfully" do
    visit "/crank_users/new"
    click_on "create"
    expect(page).to have_css ".notice", text: "Crank User created"
    crank_user = CrankUser.last
    expect(page).to have_css "h1", text: "Crank User #{crank_user.code}"
    expect(page.current_path).to eq crank_user_path(crank_user)
  end
end
