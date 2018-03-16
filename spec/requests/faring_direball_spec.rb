require 'rails_helper'

describe 'faring_direball' do
  it 'returns fixed json' do
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

    get '/faring_direball.json'

    actual = JSON.parse(response.body)
    expect(actual).to eq({
      'bonus' => 'value',
      'feed_url' => 'https://app.jonallured.com/faring_direball.json',
      'items' => [
        'author' => 'John Gruber',
        'date_published' => 'Today',
        'id' => '123',
        'title' => 'Best Post',
        'url' => 'https://daringfireball.net/best_post.html'
      ]
    })
  end
end
