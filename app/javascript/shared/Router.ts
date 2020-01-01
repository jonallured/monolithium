import { Project } from "../components/App"
import { BaseFetcher, ResponseJson } from "./BaseFetcher"

export class Router extends BaseFetcher {
  updateProject = (id: string): ResponseJson => {
    const url = `/projects/${id}.json`
    return this.sendRequest(url, "PATCH")
  }

  createProject = (newProject: Project): ResponseJson => {
    const url = "/projects.json"
    const body = {
      project: newProject
    }

    return this.sendRequest(url, "POST", body)
  }
}
