class RubygemsParser < BaseParser
  SIGNATURE_HEADER_KEY = "HTTP_AUTHORIZATION"

  def self.valid_for?(raw_hook)
    signature = raw_hook.headers[SIGNATURE_HEADER_KEY]
    gem_name = raw_hook.params["name"]
    gem_version = raw_hook.params["version"]

    api_key = Monolithium.config.rubygems_api_key
    payload = [gem_name, gem_version, api_key].join
    expected_signature = Digest::SHA2.hexdigest(payload)

    Rack::Utils.secure_compare(signature, expected_signature)
  end

  def self.can_parse?(raw_hook)
    raw_hook.headers[SIGNATURE_HEADER_KEY].present? &&
      raw_hook.params["name"].present? &&
      raw_hook.params["version"].present?
  end

  def self.parse(raw_hook)
    gem_name = raw_hook.params["name"]
    gem_version = raw_hook.params["version"]
    message = "published #{gem_name} #{gem_version}"

    raw_hook.create_hook(
      message: message,
      webhook_sender: WebhookSender.rubygems
    )
  end
end
