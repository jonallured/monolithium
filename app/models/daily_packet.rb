class DailyPacket
  def self.produce_for(date)
    file_path = "daily-packets/#{date.strftime("%Y-%m-%d")}.pdf"
    packet = DailyPacketView.new(date)
    S3Api.write(file_path, packet.pdf_data)
  end
end
