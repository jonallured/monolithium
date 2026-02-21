class BlueSkyApi
  def self.create_post(text)
    return nil unless client

    client.create_record(text)
  end
end
