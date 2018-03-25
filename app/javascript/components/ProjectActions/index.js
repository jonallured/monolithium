import React from "react"

class ErrorMessage extends React.Component {
  render() {
    const style = {
      backgroundColor: "yellow",
      color: "black",
      padding: "8px"
    }
    return <h3 style={style}>{this.props.message}</h3>
  }
}

class NewProject extends React.Component {
  handleClick = () => {
    const newProject = {
      name: this.nameInput.value
    }

    this.props.createProject(newProject)
  }

  render() {
    return (
      <section>
        <input
          type="text"
          name="name"
          placeholder="name"
          ref={input => {
            this.nameInput = input
          }}
        />
        <button onClick={this.handleClick}>Create</button>
      </section>
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
        <menu>
          <a href="#" onClick={this.toggleNewProject}>
            Create Project
          </a>
        </menu>
        {this.props.errorMessage && (
          <ErrorMessage message={this.props.errorMessage} />
        )}
        {this.state.showNewProject && <NewProject {...newProjectProps} />}
      </aside>
    )
  }
}

export default ProjectActions
