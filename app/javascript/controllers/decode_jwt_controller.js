import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "results", "token" ]

  async decode() {
    const token = this.tokenTarget.value
    const result = await this.getDecodedResult(token)
    this.resultsTarget.textContent = result
  }

  async getDecodedResult(token) {
    try {
      const response = await fetch(`/api/v1/decode_jwt?token=${token}`)
      const json = await response.json()
      const formattedResult = JSON.stringify(json, null, 2)
      return formattedResult
    } catch {
      return "error"
    }
  }
}
