require "rails_helper"

describe "faring_direball" do
  it "returns json that has been adjusted" do
    items = [
      {
        "date_published" => "Today",
        "extra" => "booo",
        "id" => "123",
        "title" => "Best Post",
        "url" => "https://daringfireball.net/best_post.html"
      }
    ]

    body = {
      "authors" => [{"name" => "John Gruber"}],
      "bonus" => "value",
      "feed_url" => "https://daringfireball.net/feed.json",
      "items" => items
    }

    res = double(:res, body: body.to_json)
    expect(Faraday).to receive(:get).and_return(res)

    get "/faring_direball"

    expect(response.parsed_body).to eq(
      "authors" => [{"name" => "John Gruber"}],
      "bonus" => "value",
      "feed_url" => "https://app.jonallured.com/faring_direball.json",
      "items" => [
        "date_published" => "Today",
        "id" => "123",
        "title" => "Best Post",
        "url" => "https://daringfireball.net/best_post.html"
      ]
    )
  end
end
