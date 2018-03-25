import React from "react"
import styled from "styled-components"

import colors from "shared/colors"

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
    width: 295px;
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
  }
`

class NewProject extends React.Component {
  handleClick = () => {
    const newProject = {
      name: this.nameInput.value
    }

    this.props.createProject(newProject)
  }

  render() {
    return (
      <Section>
        <input
          type="text"
          name="name"
          placeholder="name"
          ref={input => {
            this.nameInput = input
          }}
        />
        <button onClick={this.handleClick}>Create</button>
      </Section>
    )
  }
}

class ProjectActions extends React.Component {
  state = { showNewProject: false }

  toggleNewProject = e => {
    e.preventDefault()
    this.setState({ showNewProject: !this.state.showNewProject })
  }

  render() {
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

export default ProjectActions
