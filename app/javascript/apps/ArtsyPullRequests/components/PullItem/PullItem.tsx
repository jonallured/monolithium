import React from "react"
import styled from "styled-components"
import { PullRequest } from "../../ArtsyPullRequests"

interface ItemProps {
  backgroundColor: string
}

const Item = styled.li<ItemProps>`
  background-color: ${(props): string => props.backgroundColor};
  padding: 10px 20px;

  a {
    color: black;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
`

interface PullItemProps {
  pullRequest: PullRequest
}

export const PullItem: React.FC<PullItemProps> = (props) => {
  const { pullRequest } = props
  const content = `${pullRequest.title} by @${pullRequest.username} on ${pullRequest.repo}`

  return (
    <Item backgroundColor={pullRequest.color}>
      <a href={pullRequest.url} target="_blank" rel="noopener noreferrer">
        {content}
      </a>
    </Item>
  )
}
