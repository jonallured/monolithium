class CircleciParser
  EVENT_TYPE_KEY = "HTTP_CIRCLECI_EVENT_TYPE"
  SIGNATURE_HEADER_KEY = "HTTP_CIRCLECI_SIGNATURE"
  USER_AGENT_KEY = "HTTP_USER_AGENT"

  KNOWN_EVENT_TYPES = %w[job-completed workflow-completed]
  KNOWN_USER_AGENT = "CircleCI-Webhook/1.0"

  def self.check_and_maybe_parse(raw_hook)
    parse(raw_hook) if valid_for?(raw_hook) && can_parse?(raw_hook)
  end

  def self.valid_for?(raw_hook)
    signature = raw_hook.headers[SIGNATURE_HEADER_KEY] || ""
    actual_hmac = signature.split("=").last
    return false unless actual_hmac.present?

    digest = OpenSSL::Digest.new("sha256")
    secret = Monolithium.config.circleci_secret
    expected_hmac = OpenSSL::HMAC.hexdigest(digest, secret, raw_hook.body)

    Rack::Utils.secure_compare(actual_hmac, expected_hmac)
  end

  def self.can_parse?(raw_hook)
    header_keys = raw_hook.headers.keys
    return false unless header_keys.any?

    header_keys.include?(SIGNATURE_HEADER_KEY) &&
      raw_hook.headers[USER_AGENT_KEY] == KNOWN_USER_AGENT &&
      KNOWN_EVENT_TYPES.include?(raw_hook.headers[EVENT_TYPE_KEY])
  end

  def self.parse(raw_hook)
    parsed = JSON.parse(raw_hook.body)
    message = [
      parsed["project"]["name"],
      parsed["type"],
      parsed["workflow"]["status"],
      parsed.dig("job", "status"),
      parsed["pipeline"]["vcs"]["commit"]["subject"]
    ].compact.join(" ")
    raw_hook.create_hook(message: message)
  end
end
