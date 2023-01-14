import React from "react"
import { ProjectActions } from "./components/ProjectActions"
import { ProjectList } from "./components/ProjectList"
import { Router } from "./shared/Router"

export interface Project {
  id: string
  isTouched: boolean
  name: string
  touched_at: string
}

interface ProjectsProps {
  projects: Project[]
  router: Router
}

interface ProjectsState {
  errorMessage: string
  projects: Project[]
}

const errorMessage = "Something went wrong - project not created!"

export class Projects extends React.Component<ProjectsProps, ProjectsState> {
  constructor(props: ProjectsProps) {
    super(props)
    this.state = { errorMessage: "", projects: props.projects }
  }

  get projects(): Project[] {
    return this.state.projects
  }

  get router(): Router {
    return this.props.router
  }

  touchProject = (project: Project): void => {
    if (!project.isTouched) {
      this.router.updateProject(project.id)
      project.isTouched = true
      this.setState({ projects: this.projects })
    }
  }

  createProject = (newProject: Project): void => {
    this.router
      .createProject(newProject)
      .then((json) => this.setState({ projects: json as any }))
      .catch(() => this.setState({ errorMessage }))
  }

  render(): React.ReactNode {
    const projectActionsProps = {
      createProject: this.createProject,
      errorMessage: this.state.errorMessage,
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
