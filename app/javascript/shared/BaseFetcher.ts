export type RequestBody = object | object[]
export type ResponseJson = Promise<object | object[]>

export class BaseFetcher {
  token: string

  constructor(token: string) {
    this.token = token
  }

  sendRequest = (
    url: string,
    method: string,
    body?: RequestBody
  ): ResponseJson => {
    const headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': this.token,
    }

    const credentials: RequestCredentials = 'same-origin'

    const options = {
      body: JSON.stringify(body),
      credentials,
      headers,
      method,
    }

    return fetch(url, options).then(response => {
      if (response.status === 200) {
        return response.json()
      } else {
        throw new Error('non 200 response')
      }
    })
  }
}
