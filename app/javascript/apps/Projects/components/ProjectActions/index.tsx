import React from "react"
import styled from "styled-components"

import { colors } from "../../shared/colors"

const Menu = styled.menu`
  display: flex;
  justify-content: space-between;
  padding: 20px 0;

  a {
    color: ${colors.background};
    font-size: 24px;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
`

const ErrorMessage = styled.h3`
  background-color: ${colors.error};
  color: #000;
  padding: 8px;
`

const Section = styled.section`
  height: 70px;
  transition: height 0.1s ease-in-out;
  overflow: hidden;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;

  &.collapse {
    height: 0;
  }

  input {
    padding: 4px 0;
    font-size: 20px;
    border: none;
    width: 100%;
    background-color: ${colors.pageBackground};
    border-bottom: 8px solid ${colors.background};
    color: ${colors.text};
  }

  button {
    background-color: ${colors.background};
    color: ${colors.text};
    font-size: 20px;
    padding: 6px 16px 10px;
    border: none;
    margin-left: 20px;
  }
`

interface NewProjectProps {
  createProject: (project) => void
}

class NewProject extends React.Component<NewProjectProps> {
  handleClick = (): void => {
    const inputTag = document.querySelector(
      "input[name=name]"
    ) as HTMLInputElement

    const newProject = {
      name: inputTag.value,
    }

    this.props.createProject(newProject)
  }

  render(): React.ReactNode {
    return (
      <Section>
        <input name="name" placeholder="name" type="text" />
        <button onClick={this.handleClick}>Create</button>
      </Section>
    )
  }
}

interface ProjectActionsProps {
  createProject: (newProject) => void
  errorMessage: string
}

interface ProjectActionsState {
  showNewProject: boolean
}

export class ProjectActions extends React.Component<
  ProjectActionsProps,
  ProjectActionsState
> {
  state = { showNewProject: false }

  toggleNewProject = (event: React.MouseEvent<HTMLElement>): void => {
    event.preventDefault()
    this.setState({ showNewProject: !this.state.showNewProject })
  }

  render(): React.ReactNode {
    const newProjectProps = { createProject: this.props.createProject }
    return (
      <aside>
        <Menu>
          <a href="#" onClick={this.toggleNewProject}>
            Create Project
          </a>
        </Menu>
        {this.props.errorMessage && (
          <ErrorMessage>{this.props.errorMessage}</ErrorMessage>
        )}
        {this.state.showNewProject && <NewProject {...newProjectProps} />}
      </aside>
    )
  }
}
