class CheckBlogFeedJob < ApplicationJob
  def perform
    feed_url = "https://www.jonallured.com/atom.xml"
    response = Faraday.get(feed_url)
    doc = Nokogiri::XML(response.body)
    feed_urls = doc.css("entry id").map(&:text)
    # existing_urls = BlogPost.pluck(:url)
    existing_urls = []
    new_urls = feed_urls - existing_urls

    new_urls.each do |url|
      r = Faraday.get(url)
      post_doc = Nokogiri::HTML(r.body)
      # number = post_doc.at_css("meta[name=post_number]")["content"]
      number = 1
      summary = post_doc.at_css("meta[property='og:description']")["content"]
      title = post_doc.at_css("meta[property='og:title']")["content"]

      attrs = {
        number: number,
        summary: summary,
        title: title,
        url: url
      }

      puts attrs

      # BlogPost.create(attrs)
    end
  end
end
