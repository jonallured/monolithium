class BlogPost::Importer
  FEED_URL = "https://www.jonallured.com/atom.xml"

  def self.backfill
    response = Faraday.get("https://jonallured-public.s3.amazonaws.com/blog_post_urls.txt")
    urls = response.body.split
    existing_urls = BlogPost.pluck(:url)
    new_urls = urls - existing_urls
    new_urls.each { |url| create_from(url) }
  end

  def self.add_new
    response = Faraday.get(FEED_URL)
    doc = Nokogiri::XML(response.body)
    feed_urls = doc.css("entry id").map(&:text)
    existing_urls = BlogPost.pluck(:url)
    new_urls = feed_urls - existing_urls
    new_urls.each { |url| create_from(url) }
  end

  def self.create_from(url)
    response = Faraday.get(url)
    doc = Nokogiri::HTML(response.body)

    number = doc.at_css("meta[name=post_number]")["content"]
    summary = doc.at_css("meta[property='og:description']")["content"]
    title = doc.at_css("meta[property='og:title']")["content"]

    attrs = {
      number: number,
      summary: summary,
      title: title,
      url: url
    }

    BlogPost.create!(attrs)
  end
end
