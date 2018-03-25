import React from "react"

const ProjectItem = ({ project, touchProject }) => {
  const handleClick = () => touchProject(project)

  return (
    <li onClick={handleClick} className={project.isTouched && "touched"}>
      <span className="name">{project.name}</span>
      <span className="touched_at">{project.touched_at}</span>
    </li>
  )
}

export default ProjectItem
