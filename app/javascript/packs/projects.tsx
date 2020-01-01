import React from "react"
import ReactDOM from "react-dom"
import { Projects, Project } from "../apps/Projects"
import { Router } from "../apps/Projects/shared/Router"

declare global {
  interface Window {
    projects: Project[]
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const metaTag = document.querySelector("meta[name=csrf-token]")
  const rootTag = document.getElementById("root")

  const token = metaTag && metaTag.getAttribute("content")
  const router = new Router(token)
  const projects = window.projects

  ReactDOM.render(<Projects projects={projects} router={router} />, rootTag)
})
