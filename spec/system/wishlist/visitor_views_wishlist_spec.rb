require "rails_helper"

describe "Visitor views wishlist" do
  scenario "with available gift ideas" do
    first_gift_idea = FactoryBot.create(:available_gift_idea)
    second_gift_idea = FactoryBot.create(:available_gift_idea)
    third_gift_idea = FactoryBot.create(:available_gift_idea)

    visit "/wishlist"

    expect(page).to have_content "available"
    expect(page).to_not have_content "claimed"
    expect(page).to_not have_content "receved"

    actual_values = page.all("li").map do |li|
      [li.find("span a").text, li.find("button").text]
    end

    expect(actual_values).to eq(
      [
        [first_gift_idea.title, "claim"],
        [second_gift_idea.title, "claim"],
        [third_gift_idea.title, "claim"]
      ]
    )
  end

  scenario "with claimed gift ideas" do
    first_gift_idea = FactoryBot.create(:claimed_gift_idea)
    second_gift_idea = FactoryBot.create(:claimed_gift_idea)
    third_gift_idea = FactoryBot.create(:claimed_gift_idea)

    visit "/wishlist"

    expect(page).to_not have_content "available"
    expect(page).to have_content "claimed"
    expect(page).to_not have_content "receved"

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

  scenario "with received gift ideas" do
    FactoryBot.create_list(:received_gift_idea, 3)

    visit "/wishlist"

    expect(page).to_not have_content "available"
    expect(page).to_not have_content "claimed"
    expect(page).to_not have_content "received"

    expect(page.all("li").count).to eq 0
  end
end
