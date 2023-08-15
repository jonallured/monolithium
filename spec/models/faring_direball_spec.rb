require "rails_helper"

describe FaringDireball do
  describe ".feed_data" do
    let(:items) do
      [
        {
          "date_published" => "Today",
          "extra" => "booo",
          "id" => "123",
          "title" => "Best Post",
          "url" => "https://daringfireball.net/best_post.html"
        }
      ]
    end

    before do
      body = {
        "authors" => [{"name" => "John Gruber"}],
        "bonus" => "value",
        "feed_url" => "https://daringfireball.net/feed.json",
        "items" => items
      }

      res = double(:res, body: body.to_json)
      expect(Faraday).to receive(:get).and_return(res)
    end

    it "resets the feed_url to my version" do
      data = FaringDireball.feed_data
      expect(data["feed_url"]).to eq FaringDireball::FEED_URL
    end

    it "removes the external_url on items" do
      data = FaringDireball.feed_data
      expect(data["items"].first.keys).not_to include("external_url")
    end

    context "with a sponsor item" do
      let(:items) do
        [
          {
            "date_published" => "Today",
            "extra" => "booo",
            "id" => "123",
            "title" => "[Sponsor] Somebody gave me money",
            "url" => "https://daringfireball.net/best_post.html"
          }
        ]
      end

      it "removes that sponsor item" do
        data = FaringDireball.feed_data
        expect(data["items"].count).to eq 0
      end
    end

    context "with a my-thanks item" do
      let(:items) do
        [
          {
            "content_html" => "\n<p>My thanks to blah.</p>",
            "date_published" => "Today",
            "extra" => "booo",
            "id" => "123",
            "title" => "Could be anything",
            "url" => "https://daringfireball.net/best_post.html"
          }
        ]
      end

      it "removes that my-thanks item" do
        data = FaringDireball.feed_data
        expect(data["items"].count).to eq 0
      end
    end
  end
end
