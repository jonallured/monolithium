class DailyPacket < ApplicationRecord
  belongs_to :warm_fuzzy

  has_object :pdf_view

  has_object :producer
  delegate :save_to_disk, :save_to_s3, to: :producer

  validates :built_on, presence: true
  validates :feedbin_oldest_ago, presence: true
  validates :feedbin_unread_count, presence: true
  validates :reading_list_pace, presence: true

  def built_on_phrase
    "#{built_on.to_fs}, week #{built_on.cweek}"
  end

  def feedbin_oldest_phrase
    "oldest: #{feedbin_oldest_ago} days ago"
  end

  def feedbin_unread_phrase
    "unread: #{feedbin_unread_count}"
  end

  def reading_list_phrase
    "#{reading_list_pace} pages/day"
  end
end
