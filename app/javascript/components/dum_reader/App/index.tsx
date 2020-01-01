import React from 'react'
import styled from 'styled-components'
import { Help } from '../Help'
import { Header } from '../Header'
import { Main } from '../Main'
import { Footer } from '../Footer'
import { KeyMappings } from '../../../shared/dum_reader/KeyMappings'
import { Reader } from '../../../shared/dum_reader/Reader'
import { Entry } from '../../../shared/dum_reader/Entry'

const Wrapper = styled.div`
  font-family: Arial;
  margin: 0 auto;
  width: 960px;
`

interface AppProps {
  reader: Reader
}

interface AppState {
  entries: Entry[]
  fade: boolean
  help: string
  notice?: string
}

// this is sorta weird to do :\
declare global {
  interface Element {
    scrollIntoViewIfNeeded: () => void
  }
}

export class App extends React.Component<AppProps, AppState> {
  keyMappings: KeyMappings

  constructor(props) {
    super(props)

    this.state = {
      entries: this.props.reader.entries,
      fade: false,
      help: 'hidden',
      notice: null,
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
    window.addEventListener('webkitTransitionEnd', this.handleTransitionEnd)
    this.keyMappings.start()
  }

  componentWillUnmount(): void {
    window.removeEventListener('webkitTransitionEnd', this.handleTransitionEnd)
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
    return document.getElementsByClassName('selected')[0]
  }

  openSelected(): void {
    if (this.firstSelected()) {
      this.firstSelected()
        .getElementsByTagName('a')[0]
        .click()
    }
  }

  closeHelp = (): void => {
    this.setState({ help: 'hidden' })
  }

  openHelp = (): void => {
    this.setState({ help: 'visible' })
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
