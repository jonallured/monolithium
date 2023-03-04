window.onload = () => {
  const projectsWrapper = document.querySelector("#wrapper.projects")
  if (!projectsWrapper) return

  const metaTag = document.querySelector("meta[name=csrf-token]")
  const token = metaTag && metaTag.getAttribute("content")
  const options = {
    credentials: "same-origin",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": token,
    },
    method: "PATCH",
  }

  const projectItems = projectsWrapper.querySelectorAll(".projects ul li")

  projectItems.forEach((projectItem) => {
    projectItem.addEventListener("click", (event) => {
      event.preventDefault()
      projectItem.classList.add("touched")
      const id = projectItem.dataset.projectId
      const url = `/projects/${id}.json`
      fetch(url, options)
    })
  })
}
