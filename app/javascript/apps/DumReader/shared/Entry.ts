export class Entry {
  date: string
  feedTitle: string
  id: string
  selected: boolean
  status: string
  title: string
  url: string

  constructor(data) {
    this.id = data.id
    this.title = data.title
    this.feedTitle = data.feed_title
    this.url = data.url
    this.date = data.date
    this.status = data.status

    this.selected = false
  }

  get key(): string {
    return this.id.toString()
  }

  archive(): void {
    this.status = "archived"
  }

  save(): void {
    this.status = "saved"
  }

  markUnread(): void {
    this.status = "unread"
  }
}
