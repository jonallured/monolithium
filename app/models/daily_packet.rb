class DailyPacket
  def self.save_locally(date = Date.today)
    file_path = "tmp/daily_packet.pdf"
    warm_fuzzy = WarmFuzzy.random
    daily_packet = DailyPacket.create(built_on: date, warm_fuzzy: warm_fuzzy)
    packet = DailyPacketPdfView.new(daily_packet)
    packet.save_as(file_path)
  end

  def self.save_to_s3(date = Date.today)
    file_path = "daily-packets/#{date.strftime("%Y-%m-%d")}.pdf"
    warm_fuzzy = WarmFuzzy.random
    daily_packet = DailyPacket.create(built_on: date, warm_fuzzy: warm_fuzzy)
    packet = DailyPacketPdfView.new(daily_packet)
    S3Api.write(file_path, packet.pdf_data)
  end

  def self.create(attributes)
    new(attributes)
  end

  attr_reader :built_on, :warm_fuzzy

  def initialize(attributes)
    @built_on = attributes[:built_on]
    @warm_fuzzy = attributes[:warm_fuzzy]
  end

  def built_on_phrase
    "#{built_on.to_fs}, week #{built_on.cweek}"
  end
end
