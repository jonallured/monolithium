class DailyPacket < ApplicationRecord
  belongs_to :warm_fuzzy

  has_object :pdf_view
  delegate :pdf_data, to: :pdf_view

  has_object :producer
  delegate :save_to_disk, :save_to_s3, to: :producer

  validates :built_on, presence: true
  validates :feedbin_oldest_ago, presence: true
  validates :feedbin_unread_count, presence: true
  validates :reading_list_pace, presence: true

  def built_on_phrase
    "#{built_on.to_fs}\nweek #{built_on.cweek}"
  end

  def feedbin_oldest_phrase
    "oldest: #{feedbin_oldest_ago} days ago"
  end

  def feedbin_unread_phrase
    "unread: #{feedbin_unread_count}"
  end

  def headline_phrase
    "Daily Packet ##{id}"
  end

  def reading_list_phrase
    "#{reading_list_pace} pages/day"
  end

  def chore_list
    chores = []
    chores << "unload dishwasher"
    chores << "collect laundry" if built_on_weekend?
    chores << "defrost meat"

    if built_on_weekend? && built_during_summer?
      chores << "poop patrol"
      chores << "mow front"
      chores << "mow back"
      chores << "mow way back"
    end

    chores << "put out garbage cans" if built_on_monday?
    chores << "wipe off kitchen table"
    chores << "run dishwasher"

    chores
  end

  def built_on_monday?
    built_on.monday?
  end

  def built_on_weekend?
    built_on.saturday? || built_on.sunday?
  end

  def built_during_summer?
    (4..10).cover?(built_on.month)
  end
end
