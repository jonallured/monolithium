class SecretCheck
  def self.match?(expected, actual)
    return false if expected.blank?
    return false unless actual.is_a?(String)

    ActiveSupport::SecurityUtils.secure_compare(expected, actual)
  end

  def self.digest(value)
    return if value.blank?

    OpenSSL::HMAC.hexdigest("SHA256", Rails.application.secret_key_base, value)
  end
end
