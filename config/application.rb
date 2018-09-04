require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Monolithium
  class Application < Rails::Application
    config.active_record.schema_format = :sql
    config.generators.system_tests = nil
    config.load_defaults 5.1
  end
end
