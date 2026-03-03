require "rails_helper"
require "fugit"

describe "recurring schedules" do
  it "only has valid schedule strings" do
    config_path = Rails.root.join("config/recurring.yml")
    recurring_config = ActiveSupport::ConfigurationFile.parse(config_path)
    tasks = recurring_config.values.map(&:values).flatten
    schedules = tasks.map { |task| task["schedule"] }
    schedules.each do |schedule|
      expect(Fugit.parse(schedule)).to_not eq nil
    end
  end
end
