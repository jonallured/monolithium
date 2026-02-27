class DailyPacket < ApplicationRecord
  belongs_to :warm_fuzzy

  has_object :pdf_view
  delegate :pdf_data, to: :pdf_view

  has_object :producer
  delegate :save_to_disk, :save_to_s3, to: :producer

  validates :built_on, presence: true
  validates :edition_number, presence: true
  validates :feedbin_oldest_ago, presence: true
  validates :feedbin_unread_count, presence: true
  validates :reading_list_pace, presence: true

  def self.next_edition_number
    (DailyPacket.maximum(:edition_number) || 0) + 1
  end

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
    "Daily Packet ##{edition_number}"
  end

  def reading_list_phrase
    "#{reading_list_pace} pages/day"
  end

  def chore_list
    chores = Chore
      .where(assignee: "jon")
      .where("? = ANY(due_days)", built_on.wday)
      .order(created_at: :asc)

    chores.pluck(:title).map(&:downcase)
  end

  def start_list
    [
      "drill master password",
      "open dashboards",
      "review calendar",
      "say hi in Slack"
    ]
  end

  def stop_list
    [
      "plug in mouse",
      "say bye in Slack"
    ]
  end

  def built_on_weekend?
    built_on.saturday? || built_on.sunday?
  end
end
