require "rails_helper"

describe "Admin deletes sneaker" do
  include_context "admin password matches"

  let(:sneaker) { FactoryBot.create(:sneaker) }

  scenario "cancels delete" do
    visit "/crud/sneakers/#{sneaker.id}"

    dismiss_confirm { click_on "Delete Sneaker" }

    expect(Sneaker.count).to eq 1
    expect(page).to have_current_path crud_sneaker_path(sneaker)
  end

  scenario "confirms delete" do
    visit "/crud/sneakers/#{sneaker.id}"

    accept_confirm { click_on "Delete Sneaker" }

    expect(page).to have_css ".notice", text: "Sneaker deleted"

    expect(Sneaker.count).to eq 0
    expect(page).to have_current_path crud_sneakers_path
  end
end
