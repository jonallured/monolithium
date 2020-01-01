import React from "react"
import styled from "styled-components"
import { Help } from "./components/Help"
import { Header } from "./components/Header"
import { Main } from "./components/Main"
import { Footer } from "./components/Footer"
import { KeyMappings } from "./shared/KeyMappings"
import { Reader } from "./shared/Reader"
import { Entry } from "./shared/Entry"

const Wrapper = styled.div`
  font-family: Arial;
  margin: 0 auto;
  width: 960px;
`

// this is sorta weird to do :\
declare global {
  interface Element {
    scrollIntoViewIfNeeded: () => void
  }
}

interface DumReaderProps {
  reader: Reader
}

interface DumReaderState {
  entries: Entry[]
  fade: boolean
  help: string
  notice?: string
}

export class DumReader extends React.Component<DumReaderProps, DumReaderState> {
  keyMappings: KeyMappings

  constructor(props) {
    super(props)

    this.state = {
      entries: this.props.reader.entries,
      fade: false,
      help: "hidden",
      notice: null
    }

    this.keyMappings = new KeyMappings({ app: this, reader: this.props.reader })
    this.props.reader.refresh(this.reloadEntries)
  }

  reloadEntries = (): void => {
    this.setState({ entries: this.props.reader.entries })
  }

  updateNotice(message, fade): void {
    this.setState({ notice: message, fade: fade })
  }

  componentDidMount(): void {
    window.addEventListener("webkitTransitionEnd", this.handleTransitionEnd)
    this.keyMappings.start()
  }

  componentWillUnmount(): void {
    window.removeEventListener("webkitTransitionEnd", this.handleTransitionEnd)
    this.keyMappings.stop()
  }

  handleTransitionEnd = (): void => {
    this.updateNotice(null, false)
  }

  componentDidUpdate(): void {
    if (this.firstSelected()) {
      this.firstSelected().scrollIntoViewIfNeeded()
    }
  }

  firstSelected(): Element {
    return document.getElementsByClassName("selected")[0]
  }

  openSelected(): void {
    if (this.firstSelected()) {
      this.firstSelected()
        .getElementsByTagName("a")[0]
        .click()
    }
  }

  closeHelp = (): void => {
    this.setState({ help: "hidden" })
  }

  openHelp = (): void => {
    this.setState({ help: "visible" })
  }

  render(): React.ReactNode {
    return (
      <Wrapper>
        <Help closeHelp={this.closeHelp} visibility={this.state.help} />
        <Header openHelp={this.openHelp} />
        <Main entries={this.state.entries} />
        <Footer
          count={this.state.entries.length}
          fade={this.state.fade}
          notice={this.state.notice}
          timestamp={this.props.reader.timestamp}
          type={this.props.reader.type}
        />
      </Wrapper>
    )
  }
}
