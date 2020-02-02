import React from "react"
import styled from "styled-components"
import colors from "../../../shared/dum_reader/colors"

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

interface NoticeProps {
  notice: boolean
}

const Notice = styled.span<NoticeProps>`
  background-color: ${colors.highlight};
  color: ${colors.black};
  margin: 6px 0 0;
  padding: 4px 8px;
  visibility: ${(props): string => (props.notice ? "visible" : "hidden")};

  &.fade {
    opacity: 0;
    transition: opacity 0.5s linear 1s;
  }
`

interface FooterProps {
  count: number
  fade: boolean
  notice: string
  timestamp: string
  type: string
}

export const Footer: React.FC<FooterProps> = props => {
  const { count, fade, notice, timestamp, type } = props

  return (
    <Wrapper>
      <ByLine>
        lovingly built by <a href="http://jonallured.com">Jon Allured</a>
      </ByLine>
      <EntryCount>
        {count} {type} as of {timestamp}
      </EntryCount>
      <p>
        <Notice notice={!!notice} className={fade ? "fade" : ""}>
          {notice}
        </Notice>
      </p>
    </Wrapper>
  )
}
