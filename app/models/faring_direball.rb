class FaringDireball
  FEED_URL = "https://app.jonallured.com/faring_direball.json".freeze

  def self.feed_data
    url = "https://daringfireball.net/feeds/json"

    response = Faraday.get url

    data = JSON.parse(response.body)
    items = data["items"]

    modified_items = items.map do |item|
      item.slice "title", "date_published", "id", "url", "author"
    end

    data["feed_url"] = FEED_URL
    data["items"] = modified_items
    data
  end
end
