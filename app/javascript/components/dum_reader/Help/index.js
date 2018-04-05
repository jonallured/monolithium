import React from "react"
import styled from "styled-components"

import colors from "shared/dum_reader/colors"
import NormalModeHelp from "components/dum_reader/NormalModeHelp"
import VisualModeHelp from "components/dum_reader/VisualModeHelp"

const Wrapper = styled.div`
  position: absolute;
  top: 150px;
  visibility: ${props => props.visibility};
  width: 960px;
  z-index: 1000;
`

const Modal = styled.div`
  background-color: ${colors.black};
  border-radius: 15px;
  box-shadow: 0 0 70px 7px ${colors.black};
  color: ${colors.highlight};
  font-family: courier;
  font-size: 14px;
  margin: 0 auto;
  padding: 10px;
  position: relative;
  text-align: left;
  width: 400px;
`

const Header = styled.h2`
  border-bottom: 1px solid;
  margin: 0 0 10px;
  padding: 0 0 5px;
  text-align: center;
`

const CloseLink = styled.a`
  color: ${colors.highlight};
  font-size: 16px;
  position: absolute;
  right: 14px;
  text-decoration: none;
  top: 13px;
`

const Nav = styled.h3`
  border-top: 1px solid ${colors.highlight};
  margin: 10px 0 0;
  padding: 5px 0 0;
  text-align: center;

  a {
    color: ${colors.highlight};
  }

  a.picked {
    background-color: ${colors.highlight};
    color: ${colors.black};
    padding: 2px 8px;
    text-decoration: none;
  }
`

class Help extends React.Component {
  constructor() {
    super()

    this.state = {
      normal: true
    }
  }

  close = e => {
    e.preventDefault()
    this.props.closeHelp()
  }

  showNormal = e => {
    e.preventDefault()
    this.setState({ normal: true })
  }

  showVisual = e => {
    e.preventDefault()
    this.setState({ normal: false })
  }

  render() {
    return (
      <Wrapper visibility={this.props.visibility}>
        <Modal>
          <CloseLink href="#" onClick={this.close}>
            [X]
          </CloseLink>
          <Header>Keyboard Shortcuts</Header>
          {this.state.normal ? <NormalModeHelp /> : <VisualModeHelp />}
          <Nav>
            <a
              href="#"
              onClick={this.showNormal}
              className={this.state.normal ? "picked" : ""}
            >
              Normal Mode
            </a>
            &nbsp;|&nbsp;
            <a
              href="#"
              onClick={this.showVisual}
              className={this.state.normal ? "" : "picked"}
            >
              Visual Mode
            </a>
          </Nav>
        </Modal>
      </Wrapper>
    )
  }
}

export default Help
