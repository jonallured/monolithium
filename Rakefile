require_relative "config/application"
Rails.application.load_tasks

if %w[development test].include? Rails.env
  Rake::Task[:default].clear
  task default: %i[standard spec]
end
