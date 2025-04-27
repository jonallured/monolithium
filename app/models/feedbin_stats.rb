class FeedbinStats
  def self.compute
    new.compute
  end

  def initialize
    @unread_entry_ids = []
    @oldest_entry = {}
  end

  def compute
    get_unread_entries
    get_oldest_entry

    [unread_count, oldest_ago]
  end

  def get_unread_entries
    @unread_entry_ids = FeedbinApi.get_unread_entries
  end

  def get_oldest_entry
    return unless @unread_entry_ids.any?

    first_entry_id = @unread_entry_ids.min
    @oldest_entry = FeedbinApi.get_entry(first_entry_id)
  end

  def unread_count
    @unread_entry_ids.count
  end

  def oldest_ago
    oldest_entry_published = @oldest_entry["published"]
    return 0 unless oldest_entry_published

    oldest_published_on = Date.parse(oldest_entry_published)
    (Date.today - oldest_published_on).to_i
  end
end
