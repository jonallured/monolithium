import React from "react"
import { ProjectActions } from "../ProjectActions"
import { ProjectList } from "../ProjectList"

interface AppRouter {
  createProject: (project) => Promise<Project[]>
  updateProject: (projectId) => void
}

export interface Project {
  id: string
  isTouched: boolean
  name: string
  touched_at: string
}

interface AppProps {
  router: AppRouter
}

interface AppState {
  errorMessage: string
  projects: Project[]
}

export class App extends React.Component<AppProps, AppState> {
  constructor(props) {
    super(props)
    this.state = { errorMessage: "", projects: props.projects }
  }

  get projects(): Project[] {
    return this.state.projects
  }

  get router(): AppRouter {
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
      .then(projects => this.setState({ projects }))
      .catch(errorMessage => this.setState({ errorMessage }))
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
