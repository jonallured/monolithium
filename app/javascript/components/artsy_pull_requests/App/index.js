import React from "react"
import styled from "styled-components"

const PRList = styled.ul`
  font-size: 40px;
  list-style: none;
  line-height: 1.6em;

  a {
    color: black;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
`

export class App extends React.Component {
  state = { pullRequests: [] }

  componentDidMount() {
    const root = document.getElementById("root")
    root.addEventListener("NewPullRequest", this.handleNewPullRequest)
  }

  handleNewPullRequest = e => {
    const newPullRequest = e.detail
    this.setState({
      pullRequests: [newPullRequest, ...this.state.pullRequests]
    })
  }

  computePullRequestTags = () => {
    return this.state.pullRequests.map(pullRequest => (
      <li key={pullRequest.id}>
        <a href={pullRequest.url}>
          {pullRequest.title} by @{pullRequest.username}
        </a>
      </li>
    ))
  }

  render() {
    const pullRequestTags = this.computePullRequestTags()

    return <PRList>{pullRequestTags}</PRList>
  }
}
