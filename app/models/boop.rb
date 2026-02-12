class Boop < ApplicationRecord
  validates :display_type, presence: true
  validates :number, presence: true

  def self.latency
    next_boop = Boop.next
    return 0 unless next_boop
    Time.now.utc - next_boop.created_at
  end

  def self.next
    pending.first
  end

  def self.next_number
    (Boop.maximum(:number) || 0) + 1
  end

  def self.oldest
    where.not(dismissed_at: nil).order(created_at: :asc).first
  end

  def self.pending
    where(dismissed_at: nil).order(created_at: :asc)
  end

  def self.permitted_params
    [
      :dismissed_at,
      :display_type,
      :number
    ]
  end

  def table_attrs
    [
      ["Number", number],
      ["Display Type", display_type],
      ["Dismissed At", dismissed_at&.to_fs],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end

  def dismiss!
    update(dismissed_at: Time.now)
  end
end
