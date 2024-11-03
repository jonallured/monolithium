class DailyPacketService
  def self.build_for(date)
    reading_list = ReadingList.new
    warm_fuzzy = WarmFuzzy.random

    attributes = {
      built_on: date,
      reading_list_pace: reading_list.pace,
      warm_fuzzy: warm_fuzzy
    }

    DailyPacket.create(attributes)
  end

  def self.save_locally(date = Date.today)
    daily_packet = DailyPacketService.build_for(date)
    packet = DailyPacketPdfView.new(daily_packet)
    packet.save_as(daily_packet.local_path)
  end

  def self.save_to_s3(date = Date.today)
    daily_packet = DailyPacketService.build_for(date)
    packet = DailyPacketPdfView.new(daily_packet)
    S3Api.write(daily_packet.s3_key, packet.pdf_data)
  end
end
