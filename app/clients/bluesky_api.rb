class BlueskyApi
  def self.generate_client
    app_password = Monolithium.config.bluesky_app_password
    handle = Monolithium.config.bluesky_handle
    return unless app_password && handle

    credentials = {app_password: app_password, handle: handle}
    Tinysky::Client.new(credentials)
  end

  def self.client
    @client ||= generate_client
  end

  def self.announce(message, embed)
    return unless client

    facets = Tinysky::FacetParser.for(message)

    record_options = {
      embed: embed,
      facets: facets
    }

    client.create_record(message, record_options)
  end

  def self.setup_embed(options)
    Tinysky::ExternalEmbed.new(
      description: options[:description],
      thumb: options[:thumb],
      title: options[:title],
      uri: options[:uri]
    )
  end

  def self.upload_image(image_url)
    return unless client

    blob_data = Faraday.get(image_url).body
    content_type = "image/png"
    upload_response = client.upload_blob(blob_data, content_type)
    upload_response.body["blob"]
  end
end
