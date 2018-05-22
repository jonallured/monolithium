import React from "react"

export class App extends React.Component {
  state = { pullRequests: [] }

  handleNewPullRequest = e => {
    const newPullRequest = e.detail
    this.state.pullRequests.unshift(newPullRequest)
    this.setState({ pullRequests: this.state.pullRequests })
  }

  componentDidMount () {
    const root = document.getElementById("root")
    root.addEventListener("NewPullRequest", this.handleNewPullRequest)
  }

  render () {
    const pullRequestTags = this.state.pullRequests.map(pullRequest =>
      <li key={pullRequest.id}>
        <a href={pullRequest.url}>{pullRequest.title} by {pullRequest.username}</a>
      </li>
    )

    return (
      <ul>{pullRequestTags}</ul>
    )
  }
}
