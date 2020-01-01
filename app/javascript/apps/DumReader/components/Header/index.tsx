import React from 'react'
import styled from 'styled-components'
import { colors } from '../../shared/colors'

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

interface HeaderProps {
  openHelp: () => void
}

export const Header: React.FC<HeaderProps> = props => {
  const handler = (e): void => {
    e.preventDefault()
    props.openHelp()
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
