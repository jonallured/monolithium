ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("Rails is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "webmock/rspec"
# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
  config.include ActiveSupport::Testing::TimeHelpers
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do
    Selenium::WebDriver.logger.ignore(:deprecations)
    Capybara.server = :puma, {Silent: true}
    driven_by :selenium, using: :headless_chrome
  end
end

WebMock.disable_net_connect!(allow_localhost: true)
