import React from "react"
import { act } from "react-dom/test-utils"
import { render, screen, waitFor } from "@testing-library/react"
import { ArtsyPullRequests, ArtsyPullRequestsProps } from "./"

const pullRequest = {
  color: "black",
  id: "123",
  repo: "monolithium",
  title: "Initial commit",
  url: "https://github.com/jonallured/monolithium",
  username: "jonallured",
}

const defaultProps: ArtsyPullRequestsProps = {
  pullRequests: [],
  startListening: jest.fn(),
  stopListening: jest.fn(),
}

describe("rendering", () => {
  it("renders no items with there are no pull requests", () => {
    const props: ArtsyPullRequestsProps = {
      ...defaultProps,
      pullRequests: [],
    }

    render(<ArtsyPullRequests {...props} />)

    expect(screen.queryByRole("link")).toBeNull()
  })

  it("renders 1 item with there is 1 pull request", () => {
    const props: ArtsyPullRequestsProps = {
      ...defaultProps,
      pullRequests: [pullRequest],
    }

    render(<ArtsyPullRequests {...props} />)

    expect(screen.queryByRole("link")).toHaveTextContent(pullRequest.title)
  })

  it("renders new pull requests", async () => {
    let handleNewPullRequest

    const mockStartListening = (handler): void => {
      handleNewPullRequest = handler
    }

    const props: ArtsyPullRequestsProps = {
      ...defaultProps,
      pullRequests: [],
      startListening: mockStartListening,
    }

    render(<ArtsyPullRequests {...props} />)

    expect(screen.queryByRole("link")).toBeNull()

    act(() => {
      const event = {
        detail: pullRequest,
      }
      handleNewPullRequest(event)
    })

    expect(screen.queryByRole("link")).toHaveTextContent(pullRequest.title)
  })
})
