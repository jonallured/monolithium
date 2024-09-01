class GithubParser < BaseParser
  EVENT_TYPE_KEY = "HTTP_X_GITHUB_EVENT"
  SIGNATURE_HEADER_KEY = "HTTP_X_HUB_SIGNATURE_256"
  USER_AGENT_KEY = "HTTP_USER_AGENT"

  KNOWN_EVENT_TYPES = %w[pull_request]
  KNOWN_USER_AGENT = "GitHub-Hookshot"

  def self.valid_for?(raw_hook)
    signature = raw_hook.headers[SIGNATURE_HEADER_KEY] || ""
    actual_hmac = signature.split("=").last
    return false unless actual_hmac.present?

    digest = OpenSSL::Digest.new("sha256")
    secret = Monolithium.config.hub_signature
    expected_hmac = OpenSSL::HMAC.hexdigest(digest, secret, raw_hook.body)

    Rack::Utils.secure_compare(actual_hmac, expected_hmac)
  end

  def self.can_parse?(raw_hook)
    header_keys = raw_hook.headers.keys
    return false unless header_keys.any?

    header_keys.include?(SIGNATURE_HEADER_KEY) &&
      raw_hook.headers[USER_AGENT_KEY].include?(KNOWN_USER_AGENT) &&
      KNOWN_EVENT_TYPES.include?(raw_hook.headers[EVENT_TYPE_KEY])
  end

  def self.parse(raw_hook)
    parsed = JSON.parse(raw_hook.body)

    message = [
      parsed["repository"]["name"],
      raw_hook.headers[EVENT_TYPE_KEY],
      parsed["action"]
    ].compact.join(" ")

    raw_hook.create_hook(
      message: message,
      webhook_sender: WebhookSender.github
    )
  end
end
