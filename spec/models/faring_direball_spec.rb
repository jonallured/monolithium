require 'rails_helper'

describe FaringDireball do
  describe '.feed_data' do
    before do
      item = {
        author: 'John Gruber',
        date_published: 'Today',
        extra: 'booo',
        id: '123',
        title: 'Best Post',
        url: 'https://daringfireball.net/best_post.html'
      }

      body = {
        bonus: 'value',
        feed_url: 'https://daringfireball.net/feed.json',
        items: [item]
      }

      res = double(:res, body: body.to_json)
      expect(Faraday).to receive(:get).and_return(res)
    end

    it 'resets the feed_url to my version' do
      data = FaringDireball.feed_data
      expect(data['feed_url']).to eq FaringDireball::FEED_URL
    end

    it 'removes the external_url on items' do
      data = FaringDireball.feed_data
      expect(data['items'].first.keys).not_to include('external_url')
    end
  end
end
