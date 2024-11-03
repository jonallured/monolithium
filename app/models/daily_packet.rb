class DailyPacket < ApplicationRecord
  belongs_to :warm_fuzzy

  validates :built_on, presence: true
  validates :reading_list_pace, presence: true

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