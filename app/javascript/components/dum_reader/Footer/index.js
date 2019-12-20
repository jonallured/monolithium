import React from 'react'
import styled from 'styled-components'
import colors from '../../../shared/dum_reader/colors'

const Wrapper = styled.footer`
  border-top: 2px solid ${colors.darkGray};
  bottom: 11px;
  color: ${colors.black};
  margin: 0;
  position: absolute;
  text-align: center;
  width: 960px;

  p {
    margin: 10px 0;
    padding: 0;
  }

  a {
    color: ${colors.black};
  }
`

const ByLine = styled.p`
  float: right;
  font-style: italic;
`

const EntryCount = styled.p`
  float: left;
`

const Notice = styled.span`
  background-color: ${colors.highlight};
  color: ${colors.black};
  margin: 6px 0 0;
  padding: 4px 8px;
  visibility: ${props => (props.notice ? 'visible' : 'hidden')};

  &.fade {
    opacity: 0;
    transition: opacity 0.5s linear 1s;
  }
`

const Footer = ({ count, fade, notice, timestamp, type }) => (
  <Wrapper>
    <ByLine>
      lovingly built by <a href="http://jonallured.com">Jon Allured</a>
    </ByLine>
    <EntryCount>
      {count} {type} as of {timestamp}
    </EntryCount>
    <p>
      <Notice notice={notice} className={fade ? 'fade' : ''}>
        {notice}
      </Notice>
    </p>
  </Wrapper>
)

export default Footer
