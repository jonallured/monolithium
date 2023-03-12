class HerokuParser
  HMAC_HEADER_KEY = "HTTP_HEROKU_WEBHOOK_HMAC_SHA256"
  KNOWN_VERSION = "application/vnd.heroku+json; version=3"

  def self.check_and_maybe_parse(raw_hook)
    parse(raw_hook) if valid_for?(raw_hook) && can_parse?(raw_hook)
  end

  def self.valid_for?(raw_hook)
    actual_hmac = raw_hook.headers[HMAC_HEADER_KEY]
    return false unless actual_hmac.present?

    digest = OpenSSL::Digest.new("sha256")
    secret = Monolithium.config.heroku_secret
    calculated_hmac = OpenSSL::HMAC.digest(digest, secret, raw_hook.body)
    expected_hmac = Base64.encode64(calculated_hmac).strip

    Rack::Utils.secure_compare(actual_hmac, expected_hmac)
  end

  def self.can_parse?(raw_hook)
    header_keys = raw_hook.headers.keys
    version_param = raw_hook.params["version"]
    return false unless header_keys.any? && version_param.present?

    header_keys.include?(HMAC_HEADER_KEY) && version_param == KNOWN_VERSION
  end

  def self.parse(raw_hook)
    parsed = JSON.parse(raw_hook.body)
    message = [
      parsed["data"]["app"]["name"],
      parsed["action"],
      parsed["data"]["type"],
      parsed["data"]["command"],
      parsed["data"]["state"]
    ].join(" ")
    raw_hook.create_hook(message: message)
  end
end
