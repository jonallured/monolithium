class Router {
  sendRequest = (url, method = "GET", body = null) => {
    const clientToken = document.querySelector("#client_token").dataset.clientToken

    const headers = {
      "Content-Type": "application/json",
      "X-CLIENT-TOKEN": clientToken
    }

    const options = {
      credentials: "same-origin",
      headers,
      method
    }

    if (body) {
      options.body = JSON.stringify(body)
    }

    return fetch(url, options).then(response => response.json())
  }

  getEntries(callback) {
    const url = "/api/v1/entries.json"
    this.sendRequest(url).then(json => callback(json.payload))
  }

  updateState(state, ids) {
    const body = JSON.stringify({ state: state, ids: ids })
    const clientToken = document.querySelector("#client_token").dataset.clientToken
    const headers = {
      "Content-Type": "application/json",
      "X-CLIENT-TOKEN": clientToken
    }
    const options = {
      body: body,
      credentials: "same-origin",
      headers: headers,
      method: "POST"
    }

    fetch("/api/v1/entries.json", options)
      .then(function(response) {
        console.log(response)
      })
      .catch(function(error) {
        console.log(error)
      })
  }

  archive(ids) {
    this.updateState("archived", ids)
  }

  save(ids) {
    this.updateState("saved", ids)
  }

  markUnread(ids) {
    this.updateState("unread", ids)
  }
}

export default Router
