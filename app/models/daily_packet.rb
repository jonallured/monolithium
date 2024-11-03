class DailyPacket
  def self.create(attributes)
    new(attributes)
  end

  attr_reader :built_on, :reading_list_pace, :warm_fuzzy

  def initialize(attributes)
    @built_on = attributes[:built_on]
    @reading_list_pace = attributes[:reading_list_pace]
    @warm_fuzzy = attributes[:warm_fuzzy]
  end

  def built_on_phrase
    "#{built_on.to_fs}, week #{built_on.cweek}"
  end

  def reading_list_phrase
    "#{reading_list_pace} pages/day"
  end

  def local_path
    "tmp/daily_packet.pdf"
  end

  def s3_key
    "daily-packets/#{built_on.strftime("%Y-%m-%d")}.pdf"
  end
end
