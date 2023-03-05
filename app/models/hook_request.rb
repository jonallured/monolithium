class HookRequest
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
      body: request_body,
      headers: loud_headers,
      params: unsafe_params
    }
  end

  private

  def request_body
    @request_body ||= request.body.read
  end

  def headers_hash
    @headers_hash ||= request.headers.to_h
  end

  def loud_header_keys
    headers_hash.keys.select { |key| key == key.upcase && !key.starts_with?("ROUTES") }
  end

  def loud_headers
    headers_hash.slice(*loud_header_keys)
  end

  def unsafe_params
    params.to_unsafe_hash
  end
end
