require_relative 'config/application'
Rails.application.load_tasks

if %w[development test].include? Rails.env
  require 'rubocop/rake_task'
  desc 'Run RuboCop'
  RuboCop::RakeTask.new(:rubocop)

  desc 'run prettier check'
  task prettier_check: :environment do
    system 'yarn run prettier-check'
    abort 'prettier-check failed' unless $CHILD_STATUS.exitstatus.zero?
  end

  desc 'run jest tests'
  task jest: :environment do
    system 'yarn run test'
    abort 'jest failed' unless $CHILD_STATUS.exitstatus.zero?
  end

  Rake::Task[:default].clear
  task default: %i[prettier_check jest rubocop spec]
end
