# Monolithium Development Guide

## Common Commands
- Setup: `./bin/setup`
- Run dev server: `./bin/start`
- Run tests: `bundle exec rspec`
- Run single test: `bundle exec rspec path/to/spec.rb:LINE_NUMBER`
- Run system tests: `bundle exec rspec spec/system/`
- Lint Ruby: `./bin/rubocop`
- Ruby console: `./bin/console`

## Code Style & Conventions
- Follow Ruby/Rails conventions and Standard Ruby style guide
- Models: Use validations/associations at the top, then constants, then methods
- Controllers: Use private expose methods for variables needed in views
- Views: Use HAML with Tailwind CSS classes
- Testing: 
  - Always write tests (RSpec + FactoryBot)
  - One assertion per test when possible
  - Use descriptive context/describe blocks
- Background jobs: Use Solid Queue for async processing

## Error Handling
- Use Ruby exceptions with descriptive messages
- Validate user input at the model and controller levels
- Handle API errors gracefully with appropriate status codes
