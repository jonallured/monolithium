ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('Rails is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'
# Add additional requires below this line. Rails is not loaded until this point!
require 'webdrivers/chromedriver'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do
    Capybara.server = :puma, { Silent: true }
    driven_by :selenium_chrome_headless
  end
end

WebMock.disable_net_connect!(allow_localhost: true)

Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    loggingPrefs: { browser: 'ALL' }
  )
  opts = Selenium::WebDriver::Chrome::Options.new(options: { 'w3c' => false })

  opts.add_argument('--headless')
  opts.add_argument('--no-sandbox')
  opts.add_argument('--window-size=1440,900')

  args = {
    browser: :chrome,
    options: opts,
    desired_capabilities: caps,
    timeout: http_client_read_timout
  }

  prepare_chromedriver(args)

  Capybara::Selenium::Driver.new(app, args)
end

Capybara.configure do |config|
  config.javascript_driver = :headless_chrome
end
