require "rails_helper"

describe "Admin views apache log item" do
  include_context "admin password matches"

  scenario "from list page" do
    apache_log_item = FactoryBot.create(:apache_log_item)
    visit "/crud/apache_log_items"
    click_on apache_log_item.id.to_s
    expect(page).to have_css "h1", text: "Apache Log Item #{apache_log_item.id}"
    expect(page).to have_css "a", text: "Apache Log Item List"
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)
  end

  scenario "viewing a record" do
    apache_log_item = FactoryBot.create(
      :apache_log_item,
      REPLACE_ME: "REPLACE_ME"
    )

    visit "/crud/apache_log_items/#{apache_log_item.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["REPLACE_ME", "REPLACE_ME"],
        ["Created At", apache_log_item.created_at.to_fs],
        ["Updated At", apache_log_item.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    apache_log_item = FactoryBot.create(:apache_log_item)
    expect(ApacheLogItem).to receive(:random).and_return(apache_log_item)

    visit "/crud/apache_log_items"
    click_on "Random Apache Log Item"

    expect(page).to have_css "h1", text: "Apache Log Item #{apache_log_item.id}"
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)
  end
end
