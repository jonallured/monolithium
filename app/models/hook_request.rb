class HookRequest
  SECRET_HEADER_KEYS = [
    ApiController::CLIENT_TOKEN_HEADER
  ]

  def self.to_attrs(request, params)
    new(request, params).to_attrs
  end

  attr_reader :request, :params

  def initialize(request, params)
    @request = request
    @params = params
  end

  def to_attrs
    {
      body: computed_body,
      headers: computed_headers,
      params: computed_params
    }
  end

  private

  def computed_body
    @request_body ||= request.body&.read
  end

  def computed_headers
    headers_hash = request.headers.to_h

    header_keys = headers_hash.keys.select do |key|
      key == key.upcase && !key.starts_with?("ROUTES")
    end

    sliced_headers = headers_hash.slice(*header_keys)

    SECRET_HEADER_KEYS.each do |secret_key|
      sliced_headers[secret_key] = "REDACTED" if sliced_headers.key? secret_key
    end

    sliced_headers
  end

  def computed_params
    params.to_unsafe_hash
  end
end
