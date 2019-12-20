import React from 'react'
import styled from 'styled-components'

import colors from 'shared/colors'

const ListItem = styled.li`
  background-color: ${colors.background};
  margin: 0;
  padding: 16px;
  display: flex;

  &:hover {
    background-color: ${colors.backgroundHover};
    cursor: pointer;
  }

  &.touched {
    background-color: ${colors.backgroundDisabled};
    color: #aaa;

    &:hover {
      background-color: ${colors.backgroundDisabled};
      cursor: default;
    }
  }

  .name {
    margin: 0;
    padding: 0;
    flex-grow: 2;
  }
`

const ProjectItem = ({ project, touchProject }) => {
  const handleClick = () => touchProject(project)

  return (
    <ListItem onClick={handleClick} className={project.isTouched && 'touched'}>
      <span className="name">{project.name}</span>
      <span className="touched_at">{project.touched_at}</span>
    </ListItem>
  )
}

export default ProjectItem
