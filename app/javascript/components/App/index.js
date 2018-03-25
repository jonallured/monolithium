import React from "react"

import ProjectActions from "../ProjectActions"
import ProjectList from "../ProjectList"

class App extends React.Component {
  constructor(props) {
    super(props)
    this.state = { projects: props.projects }
  }

  get projects() {
    return this.state.projects
  }

  get router() {
    return this.props.router
  }

  touchProject = project => {
    if (!project.touched) {
      this.router.updateProject(project.id)
      project.isTouched = true
      this.setState({ projects: this.projects })
    }
  }

  createProject = newProject => {
    this.router
      .createProject(newProject)
      .then(projects => this.setState({ projects }))
      .catch(errorMessage => this.setState({ errorMessage }))
  }

  render() {
    const projectActionsProps = {
      createProject: this.createProject,
      errorMessage: this.state.errorMessage
    }

    return (
      <div>
        <ProjectActions {...projectActionsProps} />
        {this.projects.length > 0 ? (
          <ProjectList
            projects={this.projects}
            touchProject={this.touchProject}
          />
        ) : (
          <h3>No projects - create one!</h3>
        )}
      </div>
    )
  }
}

export default App
