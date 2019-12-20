import React from 'react'
import styled from 'styled-components'
import Help from '../Help'
import Header from '../Header'
import Main from '../Main'
import Footer from '../Footer'
import KeyMappings from '../../../shared/dum_reader/KeyMappings'

const Wrapper = styled.div`
  font-family: Arial;
  margin: 0 auto;
  width: 960px;
`

class App extends React.Component {
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

  reloadEntries = () => {
    this.setState({ entries: this.props.reader.entries })
  }

  updateNotice(message, fade) {
    this.setState({ notice: message, fade: fade })
  }

  componentDidMount() {
    window.addEventListener('webkitTransitionEnd', this.handleTransitionEnd)
    this.keyMappings.start()
  }

  componentWillUnmount() {
    window.removeEventListener('webkitTransitionEnd', this.handleTransitionEnd)
    this.keyMappings.stop()
  }

  handleTransitionEnd = e => {
    this.updateNotice(null, false)
  }

  componentDidUpdate() {
    if (this.firstSelected()) {
      this.firstSelected().scrollIntoViewIfNeeded()
    }
  }

  firstSelected() {
    return document.getElementsByClassName('selected')[0]
  }

  openSelected() {
    if (this.firstSelected()) {
      this.firstSelected()
        .getElementsByTagName('a')[0]
        .click()
    }
  }

  computeProps() {
    return {
      helpProps: {
        visibility: this.state.help,
        closeHelp: this.closeHelp,
      },
      headerProps: {
        openHelp: this.openHelp,
      },
      mainProps: {
        entries: this.state.entries,
      },
      footerProps: {
        count: this.state.entries.length,
        type: this.props.reader.type,
        notice: this.state.notice,
        fade: this.state.fade,
        timestamp: this.props.reader.timestamp,
      },
    }
  }

  closeHelp = () => {
    this.setState({ help: 'hidden' })
  }

  openHelp = () => {
    this.setState({ help: 'visible' })
  }

  render() {
    const {
      helpProps,
      headerProps,
      mainProps,
      footerProps,
    } = this.computeProps()

    return (
      <Wrapper>
        <Help {...helpProps} />
        <Header {...headerProps} />
        <Main {...mainProps} />
        <Footer {...footerProps} />
      </Wrapper>
    )
  }
}

export default App
