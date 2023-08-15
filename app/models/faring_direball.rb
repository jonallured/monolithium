class FaringDireball
  FEED_URL = "https://app.jonallured.com/faring_direball.json".freeze

  def self.feed_data
    url = "https://daringfireball.net/feeds/json"

    response = Faraday.get url

    data = JSON.parse(response.body)
    items = data["items"]

    filtered_items = items.reject do |item|
      item["title"].starts_with?("[Sponsor]") ||
        (item["content_html"] || "").first(20).include?("My thanks")
    end

    modified_items = filtered_items.map do |item|
      item.slice "title", "date_published", "id", "url"
    end

    data["feed_url"] = FEED_URL
    data["items"] = modified_items
    data
  end
end
