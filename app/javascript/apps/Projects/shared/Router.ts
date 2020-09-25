import { Project } from "../Projects"
import { BaseFetcher, ResponseJson } from "../../../shared/BaseFetcher"

export class Router extends BaseFetcher {
  updateProject = (id: string): ResponseJson => {
    const url = `/projects/${id}.json`
    return this.sendRequest(url, "PATCH")
  }

  createProject = (newProject: Project): ResponseJson => {
    const url = "/projects.json"
    const body = {
      project: newProject,
    }

    return this.sendRequest(url, "POST", body)
  }
}
