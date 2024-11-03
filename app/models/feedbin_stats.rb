class FeedbinStats
  def self.compute
    unread_entry_ids = FeedbinApi.get_unread_entries
    first_entry_id = unread_entry_ids.min
    oldest_entry = FeedbinApi.get_entry(first_entry_id)
    oldest_published_on = Date.parse(oldest_entry["published"])
    oldest_ago = (Date.today - oldest_published_on).to_i
    [unread_entry_ids.count, oldest_ago]
  end
end
