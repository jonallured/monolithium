require_relative 'config/application'
Rails.application.load_tasks

require 'rubocop/rake_task'
desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop)

Rake::Task[:default].clear
task default: %i[rubocop spec]
