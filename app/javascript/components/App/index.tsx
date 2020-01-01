import React from "react"
import { ProjectActions } from "../ProjectActions"
import { ProjectList } from "../ProjectList"
import { Router } from "../../shared/Router"

export interface Project {
  id: string
  isTouched: boolean
  name: string
  touched_at: string
}

interface AppProps {
  projects: Project[]
  router: Router
}

interface AppState {
  errorMessage: string
  projects: Project[]
}

const errorMessage = "Something went wrong - project not created!"

export class App extends React.Component<AppProps, AppState> {
  constructor(props) {
    super(props)
    this.state = { errorMessage: "", projects: props.projects }
  }

  get projects(): Project[] {
    return this.state.projects
  }

  get router(): Router {
    return this.props.router
  }

  touchProject = (project): void => {
    if (!project.touched) {
      this.router.updateProject(project.id)
      project.isTouched = true
      this.setState({ projects: this.projects })
    }
  }

  createProject = (newProject): void => {
    this.router
      .createProject(newProject)
      .then(json => this.setState({ projects: json as Project[] }))
      .catch(() => this.setState({ errorMessage }))
  }

  render(): React.ReactNode {
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
