import React from "react"
import styled from "styled-components"
import { ProjectItem } from "../ProjectItem"
import { Project } from "../App"

const UnorderedList = styled.ul`
  margin: 0;
  padding: 0px;
  font-size: 40px;
  list-style: none;
`

interface ProjectListProps {
  projects: Project[]
  touchProject: (project) => void
}

export const ProjectList: React.FC<ProjectListProps> = props => {
  const { projects, touchProject } = props

  const projectItems = projects.map(project => {
    return (
      <ProjectItem
        key={project.id}
        project={project}
        touchProject={touchProject}
      />
    )
  })

  return <UnorderedList>{projectItems}</UnorderedList>
}
