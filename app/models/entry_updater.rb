class EntryUpdater
  def self.update(data)
    new_state = data['state']
    ids = data['ids']

    methods = {
      'archived' => :archive_entries,
      'saved' => :star_entries,
      'unread' => :mark_entries_unread
    }

    Feedbin.public_send(methods[new_state], ids)
  end
end
