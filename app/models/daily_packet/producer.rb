class DailyPacket::Producer < ActiveRecord::AssociatedObject
  def self.save_to(target, date = Date.today)
    daily_packet = DailyPacket::Builder.find_or_build_for(date)

    if target == :disk
      daily_packet.save_to_disk
    elsif target == :s3
      daily_packet.save_to_s3
    else
      raise ArgumentError
    end
  end

  def save_to_disk
    local_path = "tmp/daily_packet.pdf"
    daily_packet.pdf_view.save_as(local_path)
  end

  def save_to_s3
    timestamp = daily_packet.built_on.strftime("%Y-%m-%d")
    s3_key = "daily-packets/#{timestamp}.pdf"
    pdf_data = daily_packet.pdf_view.pdf_data
    S3Api.write(s3_key, pdf_data)
  end
end
