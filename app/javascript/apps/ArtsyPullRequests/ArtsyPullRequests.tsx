import React, { useEffect, useState } from "react"
import { PullList } from "./components/PullList"

export interface PullRequest {
  color: string
  id: string
  repo: string
  title: string
  url: string
  username: string
}

export interface ArtsyPullRequestsProps {
  pullRequests: PullRequest[]
  startListening: (handler) => void
  stopListening: (handler) => void
}

export const ArtsyPullRequests: React.FC<ArtsyPullRequestsProps> = (props) => {
  const { startListening, stopListening } = props
  const [pullRequests, setPullRequests] = useState(props.pullRequests)

  const handleNewPullRequest = (e): void => {
    const newPullRequest = e.detail

    setPullRequests((currentPullRequests) => [
      newPullRequest,
      ...currentPullRequests,
    ])
  }

  useEffect(() => {
    startListening(handleNewPullRequest)

    return (): void => {
      stopListening(handleNewPullRequest)
    }
  }, [])

  return <PullList pullRequests={pullRequests} />
}
