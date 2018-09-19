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

  def self.unread_entries
    EntryCollection.entries(connection, Endpoint::UNREAD_ENTRIES)
  end

  def self.saved_entries
    EntryCollection.entries(connection, Endpoint::STARRED_ENTRIES)
  end

  def self.archived_entries
    EntryCollection.entries(connection, Endpoint::RECENTLY_READ_ENTRIES)
  end

  def self.archive_entries(ids)
    create_recently_read_entries(ids)

    delete_starred_entries(ids)
    delete_unread_entries(ids)
  end

  def self.mark_entries_unread(ids)
    create_unread_entries(ids)

    delete_recently_read_entries(ids)
    delete_starred_entries(ids)
  end

  def self.star_entries(ids)
    create_starred_entries(ids)

    delete_recently_read_entries(ids)
    delete_unread_entries(ids)
  end

  def self.delete_recently_read_entries(ids)
    connection.delete(Endpoint::RECENTLY_READ_ENTRIES) do |request|
      request.body = { recently_read_entries: ids }.to_json
    end
  end

  def self.delete_starred_entries(ids)
    connection.delete(Endpoint::STARRED_ENTRIES) do |request|
      request.body = { starred_entries: ids }.to_json
    end
  end

  def self.delete_unread_entries(ids)
    connection.delete(Endpoint::UNREAD_ENTRIES) do |request|
      request.body = { unread_entries: ids }.to_json
    end
  end

  def self.create_recently_read_entries(ids)
    connection.post(Endpoint::RECENTLY_READ_ENTRIES) do |request|
      request.body = { recently_read_entries: ids }.to_json
    end
  end

  def self.create_starred_entries(ids)
    connection.post(Endpoint::STARRED_ENTRIES) do |request|
      request.body = { starred_entries: ids }.to_json
    end
  end

  def self.create_unread_entries(ids)
    connection.post(Endpoint::UNREAD_ENTRIES) do |request|
      request.body = { unread_entries: ids }.to_json
    end
  end

  module Endpoint
    BASE = 'https://api.feedbin.com'.freeze
    AUTH = '/v2/authentication.json'.freeze
    SUBSCRIPTIONS = '/v2/subscriptions.json'.freeze
    UNREAD_ENTRIES = '/v2/unread_entries.json'.freeze
    ENTRIES = '/v2/entries.json'.freeze
    STARRED_ENTRIES = '/v2/starred_entries.json'.freeze
    RECENTLY_READ_ENTRIES = '/v2/recently_read_entries.json'.freeze
  end

  class EntryCollection
    def self.entries(connection, endpoint)
      new(connection, endpoint).entries
    end

    def initialize(connection, endpoint)
      @connection = connection
      @endpoint = endpoint
    end

    # rubocop:disable Metrics/AbcSize
    def entries
      uncached_entries.each do |entry|
        key = "entry/#{entry['id']}"
        value = entry.slice('id', 'feed_id', 'title', 'url', 'published')
        Rails.cache.write(key, value)
      end

      Rails.logger.info "cached_entries.count => #{cached_entries.count}"
      Rails.logger.info "uncached_entries.count => #{uncached_entries.count}"

      cached_entries + uncached_entries
    end
    # rubocop:enable Metrics/AbcSize

    private

    def entry_ids
      @entry_ids ||= JSON.parse(@connection.get(@endpoint).body)
    end

    def cached_entries
      @cached_entries ||= entry_ids.map { |id| Rails.cache.read("entry/#{id}") }.compact
    end

    def cached_ids
      cached_entries.map { |hash| hash['id'] }
    end

    def uncached_ids
      entry_ids - cached_ids
    end

    def uncached_entries
      return [] unless uncached_ids.any?

      @uncached_entries ||= JSON.parse(@connection.get("#{Endpoint::ENTRIES}?ids=#{uncached_ids.join(',')}").body)
    end
  end
end
