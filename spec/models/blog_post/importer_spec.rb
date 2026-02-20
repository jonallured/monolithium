require "rails_helper"

describe BlogPost::Importer do
  describe ".create_from" do
    context "with a nil url" do
      it "returns nil" do
        url = nil
        blog_post = BlogPost::Importer.create_from(url)
        expect(blog_post).to eq nil
      end
    end

    context "with a url that does not return HTML" do
      it "returns nil" do
        url = "https://www.jonallured.com/images/headshot.png"
        mock_body = "hi"
        mock_response = double(:mock_response, body: mock_body)
        expect(Faraday).to receive(:get).with(url).and_return(mock_response)
        blog_post = BlogPost::Importer.create_from(url)
        expect(blog_post).to eq nil
      end
    end

    context "with a valid url" do
      it "parses attrs and creates BlogPost record" do
        url = "https://www.jonallured.com/posts/2001/02/03/short-post.html"

        mock_body = <<~HTML
          <html>
            <head>
              <meta name="post_number" content="1">
              <meta property="og:description" content="Hi.">
              <meta property="og:title" content="Short Post">
            </head>
            <body>
            </body>
          </html>
        HTML

        mock_response = double(:mock_response, body: mock_body)
        expect(Faraday).to receive(:get).with(url).and_return(mock_response)

        blog_post = BlogPost::Importer.create_from(url)

        expect(blog_post.number).to eq 1
        expect(blog_post.published_on).to eq Date.new(2001, 2, 3)
        expect(blog_post.summary).to eq "Hi."
        expect(blog_post.title).to eq "Short Post"
        expect(blog_post.url).to eq url
      end
    end
  end
end
