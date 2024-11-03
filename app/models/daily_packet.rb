class DailyPacket
  def self.save_locally(date = Date.today)
    file_path = "tmp/daily_packet.pdf"
    daily_packet = DailyPacket.create(built_on: date)
    packet = DailyPacketPdfView.new(daily_packet)
    packet.save_as(file_path)
  end

  def self.save_to_s3(date = Date.today)
    file_path = "daily-packets/#{date.strftime("%Y-%m-%d")}.pdf"
    daily_packet = DailyPacket.create(built_on: date)
    packet = DailyPacketPdfView.new(daily_packet)
    S3Api.write(file_path, packet.pdf_data)
  end

  def self.create(attributes)
    new(attributes)
  end

  attr_reader :built_on

  def initialize(attributes)
    @built_on = attributes[:built_on]
  end
end
