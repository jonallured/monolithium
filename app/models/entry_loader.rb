class EntryLoader
  def self.load
    new.load
  end

  def initialize; end

  def load
    Feedbin.cache_feed_titles

    {
      archived_entries: archived_entries,
      saved_entries: saved_entries,
      unread_entries: unread_entries
    }
  end

  private

  def archived_entries
    Feedbin.archived_entries.map do |data|
      Entry.new(data, 'archived')
    end
  end

  def saved_entries
    Feedbin.saved_entries.map do |data|
      Entry.new(data, 'saved')
    end
  end

  def unread_entries
    Feedbin.unread_entries.map do |data|
      Entry.new(data, 'unread')
    end
  end
end
