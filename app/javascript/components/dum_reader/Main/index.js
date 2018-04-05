import React from "react"
import styled from "styled-components"

import EntryList from "components/dum_reader/EntryList"

const Wrapper = styled.main`
  bottom: 49px;
  overflow-y: scroll;
  position: absolute;
  top: 57px;
  width: 960px;
`

const Main = props => {
  return (
    <Wrapper>
      <EntryList {...props} />
    </Wrapper>
  )
}

export default Main
