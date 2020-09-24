import React from "react"
import styled from "styled-components"
import { PullRequest } from "../../ArtsyPullRequests"
import { PullItem } from "../PullItem"

const List = styled.ul`
  font-size: 40px;
  line-height: 1.6em;
  list-style: none;
  margin: 0;
  padding: 0;
`

interface PullListProps {
  pullRequests: PullRequest[]
}

export const PullList: React.FC<PullListProps> = (props) => {
  const { pullRequests } = props

  const items = pullRequests.map((pullRequest, i) => {
    return <PullItem key={i} pullRequest={pullRequest} />
  })

  return <List>{items}</List>
}
