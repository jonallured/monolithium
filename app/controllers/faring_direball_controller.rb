class FaringDireballController < ApplicationController
  def index
    url = 'https://daringfireball.net/feeds/json'

    response = Faraday.get url

    data = JSON.parse(response.body)
    items = data['items']

    modified_items = items.map do |item|
      item.slice 'title', 'date_published', 'id', 'url', 'author'
    end

    data['feed_url'] = 'https://app.jonallured.com/faring_direball.json'
    data['items'] = modified_items

    render json: data
  end
end
