class BlogPost::Importer
  FEED_URL = "https://www.jonallured.com/atom.xml"
  URL_PATTERN = /\/(\d\d\d\d)\/(\d\d)\/(\d\d)\/.*.html/

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
    return unless url

    response = Faraday.get(url)
    doc = Nokogiri::HTML(response.body)

    number_node = doc.at_css("meta[name=post_number]")
    summary_node = doc.at_css("meta[property='og:description']")
    title_node = doc.at_css("meta[property='og:title']")

    return unless number_node && summary_node && title_node

    number = number_node["content"]
    summary = summary_node["content"]
    title = title_node["content"]

    _skip, year, month, day = url.match(URL_PATTERN).to_a
    published_on = Date.new(year.to_i, month.to_i, day.to_i)

    attrs = {
      number: number,
      published_on: published_on,
      summary: summary,
      title: title,
      url: url
    }

    BlogPost.create!(attrs)
  end
end
