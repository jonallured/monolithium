source "https://rubygems.org"

ruby File.read(".tool-versions").split.last

gem "rails", "7.0.7"

gem "pg"
gem "puma"

gem "decent_exposure"
gem "faraday"
gem "faraday-follow_redirects"
gem "graphql-client"
gem "haml"
gem "importmap-rails"
gem "jbuilder"
gem "redcarpet"
gem "redis"
gem "sidekiq"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"

group :development do
  gem "rails-erd"
end

group :development, :test do
  gem "dotenv-rails"
  gem "pry-rails"
  gem "rspec-rails"
  gem "standard"
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "selenium-webdriver"
  gem "webmock"
end
