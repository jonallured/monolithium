import React from 'react'
import styled from 'styled-components'

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

export class App extends React.Component {
  state = { pullRequests: [] }

  componentDidMount(): void {
    const root = document.getElementById('root')
    root.addEventListener('NewPullRequest', this.handleNewPullRequest)
  }

  handleNewPullRequest = (e): void => {
    const newPullRequest = e.detail
    this.setState({
      pullRequests: [newPullRequest, ...this.state.pullRequests],
    })
  }

  computePullRequestTags = (): React.ReactNode => {
    return this.state.pullRequests.map(pullRequest => (
      <li key={pullRequest.id} style={{ backgroundColor: pullRequest.color }}>
        <a href={pullRequest.url} target="_blank" rel="noopener noreferrer">
          {pullRequest.title} by @{pullRequest.username} on {pullRequest.repo}
        </a>
      </li>
    ))
  }

  render(): React.ReactNode {
    const pullRequestTags = this.computePullRequestTags()

    return <PRList>{pullRequestTags}</PRList>
  }
}
