source 'https://rubygems.org'

ruby File.read('.tool-versions').split[1]

gem 'rails', '6.0.2.1'

gem 'pg'
gem 'puma'

gem 'decent_exposure'
gem 'faraday'
gem 'haml'
gem 'jbuilder'
gem 'redcarpet'
gem 'sass-rails'
gem 'sidekiq'
gem 'webpacker'

group :development do
  gem 'dotenv-rails'
  gem 'rails-erd'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'webdrivers'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'selenium-webdriver'
  gem 'webmock'
end
