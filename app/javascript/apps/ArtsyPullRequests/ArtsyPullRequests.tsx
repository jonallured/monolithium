import React, { useEffect, useState } from "react"
import { PullList } from "./components/PullList"
import { PullItem } from "./components/PullItem"

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

  const pullItems = pullRequests.map((pullRequest, i) => {
    return <PullItem key={i} pullRequest={pullRequest} />
  })

  return <PullList>{pullItems}</PullList>
}
