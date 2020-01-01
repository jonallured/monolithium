import { Entry } from './Entry'
import { Router } from './Router'

const sortByDate = (lhsEntry, rhsEntry): number => {
  if (lhsEntry.date < rhsEntry.date) {
    return -1
  } else if (lhsEntry.date > rhsEntry.date) {
    return 1
  } else {
    return 0
  }
}

export class Reader {
  archivedEntries = []
  entries = []
  refreshCallback?: () => void
  router: Router
  savedEntries = []
  timestamp = ''
  type = 'unread'
  unreadEntries = []

  constructor() {
    const token = 'HAHAHA'
    this.router = new Router(token)
    this.resetState([], [], [], '')
  }

  resetState = (
    archivedEntries,
    savedEntries,
    unreadEntries,
    timestamp
  ): void => {
    this.archivedEntries = archivedEntries
    this.savedEntries = savedEntries
    this.unreadEntries = unreadEntries
    this.timestamp = timestamp

    this.entries = this.unreadEntries

    if (this.entries.length) {
      this.entries[0].selected = true
    }
  }

  updateEntries = (type): void => {
    this.type = type

    switch (type) {
      case 'archived':
        this.entries = this.archivedEntries
        break
      case 'saved':
        this.entries = this.savedEntries
        break
      case 'unread':
        this.entries = this.unreadEntries
        break
    }
  }

  selectedEntries = (): Entry[] => {
    return this.entries.filter(entry => entry.selected)
  }

  refresh = (callback): void => {
    this.refreshCallback = callback
    this.router.getEntries().then(json => {
      this.handleRefresh(json['payload'])
    })
  }

  handleRefresh = (payload): void => {
    const archivedEntries = payload.archived_entries
      .map(data => new Entry(data))
      .sort(sortByDate)
    const savedEntries = payload.saved_entries
      .map(data => new Entry(data))
      .sort(sortByDate)
    const unreadEntries = payload.unread_entries
      .map(data => new Entry(data))
      .sort(sortByDate)

    this.resetState(
      archivedEntries,
      savedEntries,
      unreadEntries,
      payload.timestamp
    )
    this.refreshCallback()
  }

  clearSelected = (): void => {
    this.entries.forEach(entry => (entry.selected = false))
  }

  nextEntry = (): Entry => {
    const lastIndex = this.selectedEntries().length - 1
    const lastSelected = this.selectedEntries()[lastIndex]
    const index = this.entries.indexOf(lastSelected)
    return this.entries[index + 1]
  }

  prevEntry = (): Entry => {
    const firstSelected = this.selectedEntries()[0]
    const index = this.entries.indexOf(firstSelected)
    return this.entries[index - 1]
  }

  jumpUp = (): void => {
    this.clearSelected()
    this.entries[0].selected = true
  }

  jumpDown = (): void => {
    this.clearSelected()
    this.entries[this.entries.length - 1].selected = true
  }

  moveSelectionDown = (): void => {
    const next = this.nextEntry()
    if (next) {
      this.clearSelected()
      next.selected = true
    }
  }

  moveSelectionUp = (): void => {
    const prev = this.prevEntry()
    if (prev) {
      this.clearSelected()
      prev.selected = true
    }
  }

  growSelectionDown = (): void => {
    if (this.nextEntry()) {
      this.nextEntry().selected = true
    }
  }

  growSelectionUp = (): void => {
    if (this.prevEntry()) {
      this.prevEntry().selected = true
    }
  }

  shrinkSelection = (): void => {
    const firstSelected = this.selectedEntries()[0]
    this.clearSelected()
    firstSelected.selected = true
  }

  archiveSelected = (): void => {
    const selectedIds = this.selectedEntries().map(entry => entry.id)
    this.selectedEntries().forEach(entry => entry.archive())
    this.router.archive(selectedIds)
    this.shrinkSelection()
  }

  saveSelected = (): void => {
    const selectedIds = this.selectedEntries().map(entry => entry.id)
    this.selectedEntries().forEach(entry => entry.save())
    this.router.save(selectedIds)
    this.shrinkSelection()
  }

  markSelectedUnread = (): void => {
    const selectedIds = this.selectedEntries().map(entry => entry.id)
    this.selectedEntries().forEach(entry => entry.markUnread())
    this.router.markUnread(selectedIds)
    this.shrinkSelection()
  }
}
