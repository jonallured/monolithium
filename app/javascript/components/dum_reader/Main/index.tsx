import React from 'react'
import styled from 'styled-components'
import { EntryList } from '../EntryList'
import { Entry } from '../../../shared/dum_reader/Entry'

const Wrapper = styled.main`
  bottom: 49px;
  overflow-y: scroll;
  position: absolute;
  top: 57px;
  width: 960px;
`

interface MainProps {
  entries: Entry[]
}

export const Main: React.FC<MainProps> = props => {
  return (
    <Wrapper>
      <EntryList {...props} />
    </Wrapper>
  )
}
