source "https://rubygems.org"

ruby File.read(".tool-versions").split.last

gem "rails", "7.1.2"

gem "pg"
gem "puma"

gem "aws-sdk-s3"
gem "decent_exposure"
gem "faraday"
gem "faraday-follow_redirects"
gem "graphql-client", github: "rmosolgo/graphql-client", ref: "27ef61f"
gem "haml"
gem "importmap-rails"
gem "jbuilder"
gem "kaminari"
gem "pry-rails"
gem "redcarpet"
gem "redis"
gem "sidekiq"
gem "skylight"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"

group :development do
  gem "rails-erd"
end

group :development, :test do
  gem "dotenv-rails"
  gem "rspec-rails"
  gem "standard"
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "selenium-webdriver"
  gem "webmock"
end
