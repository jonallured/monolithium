class Boop < ApplicationRecord
  def self.next
    where(dismissed_at: nil).order(created_at: :asc).first
  end

  def self.next_number
    (Boop.maximum(:number) || 0) + 1
  end

  def dismiss!
    update(dismissed_at: Time.now)
  end
end
