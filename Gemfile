source "https://rubygems.org"

ruby File.read(".tool-versions").split.last

gem "rails", "7.0.4.2"

gem "pg"
gem "puma"

gem "decent_exposure"
gem "faraday"
gem "faraday-follow_redirects"
gem "graphql-client"
gem "haml"
gem "jbuilder"
gem "redcarpet"
gem "sidekiq", "<7"
gem "sprockets-rails"
gem "tailwindcss-rails"

group :development do
  gem "dotenv-rails"
  gem "rails-erd"
end

group :development, :test do
  gem "pry-rails"
  gem "rspec-rails"
  gem "standard"
  gem "webdrivers"
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "selenium-webdriver"
  gem "webmock"
end
