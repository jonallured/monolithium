class ArtsyViewerChannel < ApplicationCable::Channel
  CHANNEL_ID = 'artsy_viewer'.freeze

  def subscribed
    transmit initial_payload
  end

  private

  def feed_urls
    [
      'https://artsy-public.s3.amazonaws.com/artworks-of-the-day/2022-10-26.json',
      'https://artsy-public.s3.amazonaws.com/artworks-of-the-day/2022-10-27.json',
      'https://artsy-public.s3.amazonaws.com/artworks-of-the-day/2022-10-28.json',
      'https://artsy-public.s3.amazonaws.com/artworks-of-the-day/2022-10-29.json'
    ]
  end

  def initial_payload
    datases = feed_urls.map do |feed_url|
      response = Faraday.get(feed_url)
      data = response.body
      JSON.parse(data)
    end

    datases.flatten.uniq { |artwork| artwork['_id'] }
  end
end
