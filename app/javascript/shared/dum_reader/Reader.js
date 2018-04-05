import Entry from "shared/dum_reader/Entry"
import Router from "shared/dum_reader/Router"

class Reader {
  constructor() {
    this.router = new Router()
    this.refreshCallback = null

    this.type = "unread"
    this.resetState([], [], [], "")
  }

  resetState(archivedEntries, savedEntries, unreadEntries, timestamp) {
    this.archivedEntries = archivedEntries
    this.savedEntries = savedEntries
    this.unreadEntries = unreadEntries
    this.timestamp = timestamp

    this.entries = this.unreadEntries

    if (this.entries.length) {
      this.entries[0].selected = true
    }
  }

  updateEntries(type) {
    this.type = type

    switch (type) {
      case "archived":
        this.entries = this.archivedEntries
        break
      case "saved":
        this.entries = this.savedEntries
        break
      case "unread":
        this.entries = this.unreadEntries
        break
    }
  }

  selectedEntries() {
    return this.entries.filter(entry => entry.selected)
  }

  refresh(callback) {
    this.refreshCallback = callback
    this.router.getEntries(this.handleRefresh)
  }

  handleRefresh = ({
    archived_entries, // eslint-disable-line camelcase
    saved_entries, // eslint-disable-line camelcase
    unread_entries, // eslint-disable-line camelcase
    timestamp
  }) => {
    const archivedEntries = archived_entries.map(data => new Entry(data))
    const savedEntries = saved_entries.map(data => new Entry(data))
    const unreadEntries = unread_entries.map(data => new Entry(data))

    this.resetState(archivedEntries, savedEntries, unreadEntries, timestamp)
    this.refreshCallback()
  }

  clearSelected() {
    this.entries.forEach(entry => (entry.selected = false))
  }

  nextEntry() {
    const lastIndex = this.selectedEntries().length - 1
    const lastSelected = this.selectedEntries()[lastIndex]
    const index = this.entries.indexOf(lastSelected)
    return this.entries[index + 1]
  }

  prevEntry() {
    const firstSelected = this.selectedEntries()[0]
    const index = this.entries.indexOf(firstSelected)
    return this.entries[index - 1]
  }

  jumpUp() {
    this.clearSelected()
    this.entries[0].selected = true
  }

  jumpDown() {
    this.clearSelected()
    this.entries[this.entries.length - 1].selected = true
  }

  moveSelectionDown() {
    const next = this.nextEntry()
    if (next) {
      this.clearSelected()
      next.selected = true
    }
  }

  moveSelectionUp() {
    const prev = this.prevEntry()
    if (prev) {
      this.clearSelected()
      prev.selected = true
    }
  }

  growSelectionDown() {
    if (this.nextEntry()) {
      this.nextEntry().selected = true
    }
  }

  growSelectionUp() {
    if (this.prevEntry()) {
      this.prevEntry().selected = true
    }
  }

  shrinkSelection() {
    const firstSelected = this.selectedEntries()[0]
    this.clearSelected()
    firstSelected.selected = true
  }

  archiveSelected() {
    const selectedIds = this.selectedEntries().map(entry => entry.id)
    this.selectedEntries().forEach(entry => entry.archive())
    this.router.archive(selectedIds)
    this.shrinkSelection()
  }

  saveSelected() {
    const selectedIds = this.selectedEntries().map(entry => entry.id)
    this.selectedEntries().forEach(entry => entry.save())
    this.router.save(selectedIds)
    this.shrinkSelection()
  }

  markSelectedUnread() {
    const selectedIds = this.selectedEntries().map(entry => entry.id)
    this.selectedEntries().forEach(entry => entry.markUnread())
    this.router.markUnread(selectedIds)
    this.shrinkSelection()
  }
}

export default Reader
