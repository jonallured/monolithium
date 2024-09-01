class BaseParser
  def self.check_and_maybe_parse(raw_hook)
    parse(raw_hook) if valid_for?(raw_hook) && can_parse?(raw_hook)
  end

  def self.can_parse?(raw_hook)
    raise StandardError
  end

  def self.valid_for?(raw_hook)
    raise StandardError
  end

  def self.parse(raw_hook)
    raise StandardError
  end
end
