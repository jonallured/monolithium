import React, { useEffect, useState } from "react"
import styled from "styled-components"

const PRList = styled.ul`
  font-size: 40px;
  line-height: 1.6em;
  list-style: none;
  margin: 0;
  padding: 0;

  li {
    padding: 10px 20px;
  }

  a {
    color: black;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
`

export const ArtsyPullRequests: React.FC = () => {
  const [pullRequests, setPullRequests] = useState([])

  const handleNewPullRequest = (e): void => {
    const newPullRequest = e.detail

    setPullRequests(currentPullRequests => [
      newPullRequest,
      ...currentPullRequests
    ])
  }

  useEffect(() => {
    const root = document.getElementById("root")
    root.addEventListener("NewPullRequest", handleNewPullRequest)

    return (): void => {
      root.removeEventListener("NewPullRequest", handleNewPullRequest)
    }
  }, [])

  const pullRequestTags = pullRequests.map(pullRequest => {
    return (
      <li key={pullRequest.id} style={{ backgroundColor: pullRequest.color }}>
        <a href={pullRequest.url} target="_blank" rel="noopener noreferrer">
          {pullRequest.title} by @{pullRequest.username} on {pullRequest.repo}
        </a>
      </li>
    )
  })

  return <PRList>{pullRequestTags}</PRList>
}
