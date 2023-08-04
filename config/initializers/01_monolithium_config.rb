module Monolithium
  def self.config
    @config ||= create_config
  end

  private_class_method def self.create_config
    attributes = load_config
    Struct.new("Config", *attributes.keys, keyword_init: true)
    Struct::Config.new(attributes)
  end

  private_class_method def self.load_config
    credentials = Rails.application.credentials
    name = Rails.env.to_sym
    credentials[name]
  end
end

Monolithium.config
