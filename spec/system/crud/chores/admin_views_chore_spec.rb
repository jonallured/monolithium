require "rails_helper"

describe "Admin views chore" do
  include_context "admin password matches"

  scenario "from list page" do
    chore = FactoryBot.create(:chore)
    visit "/crud/chores"
    click_on chore.id.to_s
    expect(page).to have_css "h1", text: "Chore #{chore.id}"
    expect(page).to have_css "a", text: "Chore List"
    expect(page).to have_current_path crud_chore_path(chore)
  end

  scenario "viewing a record" do
    chore = FactoryBot.create(
      :chore,
      assignee: 2,
      due_days: [1, 3, 5],
      title: "Clean Up"
    )

    visit "/crud/chores/#{chore.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "Clean Up"],
        ["Assignee", "jack"],
        ["Due Days", "1 3 5"],
        ["Created At", chore.created_at.to_fs],
        ["Updated At", chore.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    chore = FactoryBot.create(:chore)
    expect(Chore).to receive(:random).and_return(chore)

    visit "/crud/chores"
    click_on "Random Chore"

    expect(page).to have_css "h1", text: "Chore #{chore.id}"
    expect(page).to have_current_path crud_chore_path(chore)
  end
end
