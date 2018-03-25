import React from "react"
import styled from "styled-components"

import ProjectItem from "../ProjectItem"

const UnorderedList = styled.ul`
  margin: 0;
  padding: 0px;
  font-size: 40px;
  list-style: none;
`

const ProjectList = ({ projects, touchProject }) => {
  const projectItems = projects.map(project => {
    const props = {
      key: project.id,
      project: project,
      touchProject: touchProject
    }

    return <ProjectItem {...props} />
  })

  return <UnorderedList>{projectItems}</UnorderedList>
}

export default ProjectList
