import React from "react"
import ReactDOM from "react-dom"
import {
  ArtsyPullRequests,
  ArtsyPullRequestsProps,
} from "../apps/ArtsyPullRequests"

const eventName = "NewPullRequest"

document.addEventListener("DOMContentLoaded", () => {
  const root = document.getElementById("root")

  const startListening = (handler): void => {
    root.addEventListener(eventName, handler)
  }

  const stopListening = (handler): void => {
    root.removeEventListener(eventName, handler)
  }

  const props: ArtsyPullRequestsProps = {
    pullRequests: [],
    startListening,
    stopListening,
  }

  ReactDOM.render(<ArtsyPullRequests {...props} />, root)
})
