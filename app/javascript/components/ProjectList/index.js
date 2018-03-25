import React from "react"

import ProjectItem from "../ProjectItem"

const ProjectList = ({ projects, touchProject }) => {
  const projectItems = projects.map(project => {
    const props = {
      key: project.id,
      project: project,
      touchProject: touchProject
    }

    return <ProjectItem {...props} />
  })

  return <ul>{projectItems}</ul>
}

export default ProjectList
