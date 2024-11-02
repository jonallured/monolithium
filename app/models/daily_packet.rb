class DailyPacket
  def self.save_locally(date = Date.today)
    file_path = "tmp/daily_packet.pdf"
    packet = DailyPacketView.new(date)
    packet.save_as(file_path)
  end

  def self.save_to_s3(date = Date.today)
    file_path = "daily-packets/#{date.strftime("%Y-%m-%d")}.pdf"
    packet = DailyPacketView.new(date)
    S3Api.write(file_path, packet.pdf_data)
  end
end
