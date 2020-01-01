class Entry
  attr_reader :status

  def initialize(data, status)
    @data = data
    @status = status
  end

  def id
    @data['id']
  end

  def title
    data_title = @data['title'] || ''
    CGI.unescapeHTML data_title
  end

  def feed_title
    Rails.cache.read("feed/#{@data['feed_id']}")
  end

  def url
    @data['url']
  end

  def date
    Date.parse(@data['published']).strftime('%m/%d/%y')
  end

  def as_json(_options)
    {
      date: date,
      feed_title: feed_title,
      id: id,
      status: status,
      title: title,
      url: url
    }
  end
end
