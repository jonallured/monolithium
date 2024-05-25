require "rails_helper"

describe "Visitor views sneakers page" do
  scenario "with no sneakers" do
    visit "/sneakers"
    sneaker_sections = page.all("section")
    expect(sneaker_sections.count).to eq 0
  end

  scenario "with a few sneakers" do
    FactoryBot.create_list :sneaker, 3
    visit "/sneakers"
    sneaker_sections = page.all("section")
    expect(sneaker_sections.count).to eq 3
  end
end
