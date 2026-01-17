class S3Api
  BUCKET_NAME = "mli-data"

  def self.generate_client
    aws_access_key = Monolithium.config.aws_access_key
    aws_region = Monolithium.config.aws_region
    aws_secret_key = Monolithium.config.aws_secret_key
    return unless aws_access_key && aws_region && aws_secret_key

    credentials = Aws::Credentials.new(aws_access_key, aws_secret_key)
    Aws::S3::Client.new(credentials: credentials, region: aws_region)
  end

  def self.client
    @client ||= generate_client
  end

  def self.list(prefix)
    return unless client

    begin
      options = {bucket: BUCKET_NAME, prefix: prefix, start_after: prefix}
      response = client.list_objects_v2(options)
      response.contents.map(&:key).sort
    rescue Aws::S3::Errors::NoSuchKey => e
      Rails.logger.error("bad S3Api.read key: #{key}")
      raise e
    end
  end

  def self.move(source_key, destination_key)
    return unless client

    begin
      copy_source = "#{BUCKET_NAME}/#{source_key}"
      options = {bucket: BUCKET_NAME, copy_source: copy_source, key: destination_key}
      client.copy_object(options)
      client.delete_object(bucket: BUCKET_NAME, key: source_key)
      destination_key
    rescue Aws::S3::Errors::NoSuchKey => e
      Rails.logger.error("bad S3Api.move source key: #{source_key}")
      raise e
    end
  end

  def self.read(key)
    return unless client

    begin
      response = client.get_object(bucket: BUCKET_NAME, key: key)
      response.body.read
    rescue Aws::S3::Errors::NoSuchKey => e
      Rails.logger.error("bad S3Api.read key: #{key}")
      raise e
    end
  end

  def self.write(key, data)
    return unless client

    client.put_object(body: data, bucket: BUCKET_NAME, key: key)
  end
end
