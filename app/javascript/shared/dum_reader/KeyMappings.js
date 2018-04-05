class KeyMappings {
  constructor({ app, reader }) {
    this.app = app
    this.reader = reader

    this.mode = "normal"
    this.modifier = null
  }

  start() {
    window.addEventListener("keydown", this.handleKeyUp)
  }

  stop() {
    window.removeEventListener("keydown", this.handleKeyUp)
  }

  handleKeyUp = e => {
    const keyCode = e.keyCode

    if (this.mode === "visual") {
      this.visual(keyCode)
    } else if (this.modifier) {
      this.handleModified(keyCode)
      this.modifier = null
    } else {
      this.unmodified(keyCode)
    }
  }

  handleModified(keyCode) {
    switch (this.modifier) {
      case "g":
        this.geeModified(keyCode)
        break
      case "shift":
        this.shiftModified(keyCode)
        break
    }
  }

  unmodified(keyCode) {
    switch (keyCode) {
      case 13: // return
        this.app.openSelected()
        break
      case 16: // shift
        this.modifier = "shift"
        break
      case 17: // control
        this.modifier = "control"
        break
      case 18: // option
        this.modifier = "option"
        break
      case 27: // esc
        this.app.closeHelp()
        break
      case 65: // a
        this.reader.archiveSelected()
        this.app.reloadEntries()
        break
      case 71: // g
        this.modifier = "g"
        break
      case 74: // j
        this.reader.moveSelectionDown()
        this.app.reloadEntries()
        break
      case 75: // k
        this.reader.moveSelectionUp()
        this.app.reloadEntries()
        break
      case 76: // l
        this.modifier = "l"
        break
      case 82: // r
        this.app.updateNotice("refreshing...", true)
        this.reader.refresh(this.app.reloadEntries)
        break
      case 83: // s
        this.reader.saveSelected()
        this.app.reloadEntries()
        break
      case 85: // u
        this.reader.markSelectedUnread()
        this.app.reloadEntries()
        break
      case 86: // v
        this.mode = "visual"
        this.app.updateNotice("visual mode", false)
        break
      case 91: // command
        this.modifier = "command"
        break
      default:
        break
    }
  }

  visual(keyCode) {
    switch (keyCode) {
      case 27: // esc
      case 86: // v
        this.exitVisual()
        break
      case 65: // a
        this.reader.archiveSelected()
        this.exitVisual()
        break
      case 74: // j
        this.reader.growSelectionDown()
        this.app.reloadEntries()
        break
      case 75: // k
        this.reader.growSelectionUp()
        this.app.reloadEntries()
        break
      case 83: // s
        this.reader.saveSelected()
        this.exitVisual()
        break
      case 85: // u
        this.reader.markSelectedUnread()
        this.exitVisual()
        break
    }
  }

  exitVisual() {
    this.mode = "normal"
    this.reader.shrinkSelection()
    this.app.updateNotice("normal mode", true)
    this.app.reloadEntries()
  }

  geeModified(keyCode) {
    switch (keyCode) {
      case 65: // g + a
        this.reader.updateEntries("archived")
        this.app.reloadEntries()
        break
      case 71: // g + g
        this.reader.jumpUp()
        this.app.reloadEntries()
        break
      case 83: // g + s
        this.reader.updateEntries("saved")
        this.app.reloadEntries()
        break
      case 85: // g + u
        this.reader.updateEntries("unread")
        this.app.reloadEntries()
        break
    }
  }

  shiftModified(keyCode) {
    switch (keyCode) {
      case 71: // G
        this.reader.jumpDown()
        this.app.reloadEntries()
        break
      case 191: // ?
        this.app.openHelp()
        break
    }
  }
}

export default KeyMappings
