class FeedbinStats
  def self.compute
    unread_entry_ids = FeedbinApi.get_unread_entries
    return [0, 0] unless unread_entry_ids.any?

    first_entry_id = unread_entry_ids.min
    oldest_entry = FeedbinApi.get_entry(first_entry_id)
    oldest_entry_published = oldest_entry["published"]
    return [unread_entry_ids.count, 0] unless oldest_entry_published

    oldest_published_on = Date.parse(oldest_entry_published)
    oldest_ago = (Date.today - oldest_published_on).to_i
    [unread_entry_ids.count, oldest_ago]
  end
end
