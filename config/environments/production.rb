Rails.application.configure do
  config.action_controller.perform_caching = true
  config.action_mailer.perform_caching = false
  config.active_job.queue_adapter = :sidekiq
  config.active_record.dump_schema_after_migration = false
  config.active_storage.service = :amazon
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.force_ssl = true
  config.i18n.fallbacks = true
  config.log_formatter = Logger::Formatter.new
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.read_encrypted_secrets = true

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
