class DailyPacket::Builder
  def self.find_or_build_for(built_on)
    daily_packet = DailyPacket.find_or_initialize_by(built_on: built_on)
    return daily_packet if daily_packet.persisted?

    reading_list = ReadingList.new
    warm_fuzzy = WarmFuzzy.random

    attributes = {
      reading_list_pace: reading_list.pace,
      warm_fuzzy: warm_fuzzy
    }

    daily_packet.update(attributes)
    daily_packet
  end
end
