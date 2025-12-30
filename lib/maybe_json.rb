module MaybeJson
  def self.parse(source, opts = nil)
    JSON.parse(source.to_s, opts)
  rescue JSON::ParserError
    nil
  end
end
