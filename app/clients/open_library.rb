class OpenLibrary
  ENDPOINT_URL = "https://openlibrary.org".freeze

  def self.generate_client
    Faraday.new(
      url: ENDPOINT_URL,
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
    url = "/isbn/#{isbn}.json"
    response = client.get(url)
    response.body
  end
end
