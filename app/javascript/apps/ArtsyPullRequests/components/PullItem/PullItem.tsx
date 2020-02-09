import React from "react"

export interface PullRequest {
  color: string
  id: string
  repo: string
  title: string
  url: string
  username: string
}

interface PullItemProps {
  pullRequest: PullRequest
}

export const PullItem: React.FC<PullItemProps> = props => {
  const { pullRequest } = props
  const content = `${pullRequest.title} by @${pullRequest.username} on ${pullRequest.repo}`

  return (
    <li style={{ backgroundColor: pullRequest.color }}>
      <a href={pullRequest.url} target="_blank" rel="noopener noreferrer">
        {content}
      </a>
    </li>
  )
}
