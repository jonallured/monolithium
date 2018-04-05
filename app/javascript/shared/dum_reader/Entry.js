class Entry {
  constructor(data) {
    this.id = data.id
    this.title = data.title
    this.feedTitle = data.feed_title
    this.url = data.url
    this.date = data.date
    this.status = data.status

    this.selected = false
  }

  get key() {
    return this.id.toString()
  }

  archive() {
    this.status = "archived"
  }

  save() {
    this.status = "saved"
  }

  markUnread() {
    this.status = "unread"
  }
}

export default Entry
