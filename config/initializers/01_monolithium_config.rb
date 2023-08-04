module Monolithium
  def self.config
    @config ||= create_config
  end

  private_class_method def self.create_config
    attributes = Rails.application.credentials[Rails.env.to_sym]
    Struct.new("Config", *attributes.keys, keyword_init: true)
    Struct::Config.new(attributes)
  end
end

Monolithium.config
