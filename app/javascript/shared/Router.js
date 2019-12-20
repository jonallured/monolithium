class Router {
  constructor(token) {
    this.token = token
  }

  updateProject = id => {
    const url = `/projects/${id}.json`
    return this.sendRequest(url, null, 'PATCH')
  }

  createProject = newProject => {
    const url = '/projects.json'
    const body = {
      project: newProject,
    }

    return this.sendRequest(url, body, 'POST')
  }

  sendRequest = (url, body, method) => {
    const headers = {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': this.token,
    }

    const options = {
      body: JSON.stringify(body),
      credentials: 'same-origin',
      headers,
      method,
    }

    return fetch(url, options).then(function(response) {
      if (response.status === 200) {
        return response.json()
      } else {
        throw 'Something went wrong - project not created!'
      }
    })
  }
}

export default Router
