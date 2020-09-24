import React from "react"
import { act } from "react-dom/test-utils"
import { mount } from "enzyme"
import { ArtsyPullRequests, ArtsyPullRequestsProps } from "./"
import { PullList } from "./components/PullList"
import { PullItem } from "./components/PullItem"

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

    const wrapper = mount(<ArtsyPullRequests {...props} />)

    expect(wrapper.find(PullList)).toHaveLength(1)
    expect(wrapper.find(PullItem)).toHaveLength(0)
  })

  it("renders 1 item with there is 1 pull request", () => {
    const props: ArtsyPullRequestsProps = {
      ...defaultProps,
      pullRequests: [pullRequest],
    }

    const wrapper = mount(<ArtsyPullRequests {...props} />)

    expect(wrapper.find(PullItem)).toHaveLength(1)
  })

  it("renders new pull requests", () => {
    let handleNewPullRequest

    const mockStartListening = (handler): void => {
      handleNewPullRequest = handler
    }

    const props: ArtsyPullRequestsProps = {
      ...defaultProps,
      pullRequests: [],
      startListening: mockStartListening,
    }

    const wrapper = mount(<ArtsyPullRequests {...props} />)

    expect(wrapper.find(PullItem)).toHaveLength(0)

    act(() => {
      const event = {
        detail: pullRequest,
      }
      handleNewPullRequest(event)
    })

    wrapper.update()

    expect(wrapper.find(PullItem)).toHaveLength(1)
  })
})
