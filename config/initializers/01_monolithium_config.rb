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
    name = ENV.fetch("CREDS_GROUP", "invalid").to_sym
    group = credentials[name]

    raise "CREDS_GROUP '#{name}' not found" unless group

    map_config(group)
  end

  private_class_method def self.map_config(group)
    {
      admin_password: group[:admin_password],
      client_token: group[:client_token],
      feedbin_password: group[:feedbin_password],
      feedbin_username: group[:feedbin_username],
      heroku_secret: group[:heroku_secret],
      hub_signature: group[:hub_signature]
    }
  end
end

Monolithium.config
