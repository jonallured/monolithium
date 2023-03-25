class OpenLibrary
  def self.generate_client
    endpoint_url = Monolithium.config.open_library_endpoint_url
    return unless endpoint_url

    Faraday.new(
      url: endpoint_url,
      headers: {"Content-Type" => "application/json"}
    ) do |f|
      f.adapter Faraday.default_adapter
      f.response :follow_redirects
      f.response :json
    end
  end

  def self.client
    @client ||= generate_client
  end

  def self.get_book(isbn)
    return unless client

    url = "/isbn/#{isbn}.json"
    response = client.get(url)
    response.body
  end
end
