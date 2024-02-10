require "rails_helper"

describe "Admin views gift ideas" do
  include_context "admin password matches"

  scenario "views gift ideas" do
    FactoryBot.create_list(:gift_idea, 11)
    visit "/admin/gift_ideas"
    expect(page.all("li").count).to eq 10
  end
end
