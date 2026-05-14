require "rails_helper"

describe "Admin views training day" do
  include_context "admin password matches"

  scenario "from list page" do
    training_day = FactoryBot.create(:training_day)
    visit "/crud/training_days"
    click_on training_day.id.to_s
    expect(page).to have_css "h1", text: "Training Day #{training_day.id}"
    expect(page).to have_css "a", text: "Training Day List"
    expect(page).to have_current_path crud_training_day_path(training_day)
  end

  scenario "viewing a record" do
    training_day = FactoryBot.create(
      :training_day,
      date: Date.today,
      intensity: "lift",
      with_coach: true
    )

    visit "/crud/training_days/#{training_day.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Date", training_day.date.to_fs],
        ["Intensity", "lift"],
        ["With Coach", "true"],
        ["Completed At", "NIL"],
        ["Created At", training_day.created_at.to_fs],
        ["Updated At", training_day.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    training_day = FactoryBot.create(:training_day)
    expect(TrainingDay).to receive(:random).and_return(training_day)

    visit "/crud/training_days"
    click_on "Random Training Day"

    expect(page).to have_css "h1", text: "Training Day #{training_day.id}"
    expect(page).to have_current_path crud_training_day_path(training_day)
  end
end
