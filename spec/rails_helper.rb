ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("Rails is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "webmock/rspec"
# Add additional requires below this line. Rails is not loaded until this point!

require File.expand_path("support/shared", __dir__)

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
  config.include ActiveJob::TestHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  config.before do
    ActiveJob::Base.queue_adapter = :test
    Kaminari.config.default_per_page = 3
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end

Capybara.configure do |config|
  config.exact_text = true
end

WebMock.disable_net_connect!(allow_localhost: true)
