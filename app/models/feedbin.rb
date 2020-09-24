class Feedbin
  def self.connection
    @connection ||= Faraday.new(url: Endpoint::BASE) do |faraday|
      faraday.basic_auth(
        Rails.application.secrets.feedbin_username,
        Rails.application.secrets.feedbin_password
      )
      # might not really need this?
      faraday.headers['Content-Type'] = 'application/json; charset=utf-8'
      faraday.adapter Faraday.default_adapter
    end
  end

  # rubocop:disable Metrics/AbcSize
  def self.cache_feed_titles
    etag = Rails.cache.read("etags/#{Endpoint::SUBSCRIPTIONS}")

    response = connection.get(Endpoint::SUBSCRIPTIONS) do |request|
      request.headers['If-None-Match'] = etag if etag
    end

    return unless response.status == 200

    Rails.cache.write("etags/#{Endpoint::SUBSCRIPTIONS}", response.headers['etag'])
    subscriptions = JSON.parse(response.body)
    subscriptions.each do |subscription|
      Rails.cache.write("feed/#{subscription['feed_id']}", subscription['title'])
    end
  end
  # rubocop:enable Metrics/AbcSize

  module Endpoint
    BASE = 'https://api.feedbin.com'.freeze
    AUTH = '/v2/authentication.json'.freeze
    SUBSCRIPTIONS = '/v2/subscriptions.json'.freeze
  end
end
