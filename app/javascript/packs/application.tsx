import React from 'react'
import ReactDOM from 'react-dom'
import { App, Project } from '../components/App'
import { Router } from '../shared/Router'

declare global {
  interface Window {
    projects: Project[]
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const metaTag = document.querySelector('meta[name=csrf-token]')
  const rootTag = document.getElementById('root')

  const token = metaTag && metaTag.getAttribute('content')
  const router = new Router(token)
  const projects = window.projects

  ReactDOM.render(<App projects={projects} router={router} />, rootTag)
})
