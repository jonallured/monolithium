class FeedbinApi
  def self.generate_client
    endpoint_url = Monolithium.config.feedbin_endpoint_url
    password = Monolithium.config.feedbin_password
    username = Monolithium.config.feedbin_username
    return unless endpoint_url && password && username

    Faraday.new(url: endpoint_url) do |f|
      f.adapter Faraday.default_adapter
      f.request :authorization, :basic, username, password
      f.request :json
      f.response :json
    end
  end

  def self.client
    @client ||= generate_client
  end

  def self.get_unread_entries
    return unless client

    url = "/v2/unread_entries.json"
    response = client.get(url)
    response.body
  end

  def self.get_entry(entry_id)
    return unless client

    url = "/v2/entries/#{entry_id}.json"
    response = client.get(url)
    response.body
  end
end
