require "rails_helper"

describe "Admin views wishlist" do
  include_context "admin password matches"

  scenario "with available gift ideas" do
    first_gift_idea = FactoryBot.create(:available_gift_idea)
    second_gift_idea = FactoryBot.create(:available_gift_idea)
    third_gift_idea = FactoryBot.create(:available_gift_idea)

    visit "/wishlist"

    expect(page).to have_css "h2", text: "available"
    expect(page).to_not have_css "h2", text: "claimed"
    expect(page).to_not have_css "h2", text: "receved"

    actual_values = page.all("li").map do |li|
      [li.find("span a").text, li.find("button").text]
    end

    expect(actual_values).to eq(
      [
        [first_gift_idea.title, "receive"],
        [second_gift_idea.title, "receive"],
        [third_gift_idea.title, "receive"]
      ]
    )
  end

  scenario "with claimed gift ideas" do
    first_gift_idea = FactoryBot.create(:claimed_gift_idea)
    second_gift_idea = FactoryBot.create(:claimed_gift_idea)
    third_gift_idea = FactoryBot.create(:claimed_gift_idea)

    visit "/wishlist"

    expect(page).to have_css "h2", text: "available"
    expect(page).to_not have_css "h2", text: "claimed"
    expect(page).to_not have_css "h2", text: "receved"

    actual_values = page.all("li").map do |li|
      [li.find("span a").text, li.find("button").text]
    end

    expect(actual_values).to eq(
      [
        [first_gift_idea.title, "receive"],
        [second_gift_idea.title, "receive"],
        [third_gift_idea.title, "receive"]
      ]
    )
  end

  scenario "with received gift ideas" do
    first_gift_idea = FactoryBot.create(:received_gift_idea)
    second_gift_idea = FactoryBot.create(:received_gift_idea)
    third_gift_idea = FactoryBot.create(:received_gift_idea)

    visit "/wishlist"

    expect(page).to_not have_css "h2", text: "available"
    expect(page).to_not have_css "h2", text: "claimed"
    expect(page).to have_css "h2", text: "received"

    actual_values = page.all("li").map do |li|
      [li.find("span a").text, li.find("button").text]
    end

    expect(actual_values).to eq(
      [
        [first_gift_idea.title, "undo"],
        [second_gift_idea.title, "undo"],
        [third_gift_idea.title, "undo"]
      ]
    )
  end
end
