require "rails_helper"

describe "Admin deletes raw hook" do
  include_context "admin password matches"

  let(:raw_hook) { FactoryBot.create(:raw_hook) }

  scenario "cancels delete" do
    visit "/crud/raw_hooks/#{raw_hook.id}"

    dismiss_confirm { click_on "Delete Raw Hook" }

    expect(RawHook.count).to eq 1
    expect(page).to have_current_path crud_raw_hook_path(raw_hook)
  end

  scenario "confirms delete" do
    visit "/crud/raw_hooks/#{raw_hook.id}"

    accept_confirm { click_on "Delete Raw Hook" }

    expect(page).to have_css ".notice", text: "Raw Hook deleted"

    expect(RawHook.count).to eq 0
    expect(page).to have_current_path crud_raw_hooks_path
  end
end
