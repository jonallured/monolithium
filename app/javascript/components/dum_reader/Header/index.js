import React from 'react'
import styled from 'styled-components'
import colors from '../../../shared/dum_reader/colors'

const Wrapper = styled.header`
  border-bottom: 2px solid ${colors.darkGray};
  padding-top: 10px;

  h1 {
    color: ${colors.black};
    font-size: 32px;
    margin: 0;
    padding: 0;
  }

  a {
    color: ${colors.black};
  }
`

const ShortcutLink = styled.p`
  float: right;
`

const Header = ({ openHelp }) => {
  const handler = e => {
    e.preventDefault()
    openHelp()
  }

  return (
    <Wrapper>
      <ShortcutLink>
        <a href="#" onClick={handler}>
          :help
        </a>
      </ShortcutLink>
      <h1>Dum Reader</h1>
    </Wrapper>
  )
}

export default Header
