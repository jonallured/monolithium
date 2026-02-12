class Boop < ApplicationRecord
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

  def dismiss!
    update(dismissed_at: Time.now)
  end
end
