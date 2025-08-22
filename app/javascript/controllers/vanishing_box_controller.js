import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  initialize() {
    const channelName = "VanishingBoxChannel"
    const eventHandlers = {
      received: this.handleReceived.bind(this)
    }

    consumer.subscriptions.create(channelName, eventHandlers)
  }

  handleReceived(data) {
    const timestampNode = document.createTextNode(data.created_at)
    const parElement = document.createElement("p")
    parElement.appendChild(timestampNode)

    const bodyNode = document.createTextNode(data.body)
    const codeElement = document.createElement("code")
    codeElement.appendChild(bodyNode)

    const preElement = document.createElement("pre")
    preElement.className = "text-off-black"
    preElement.appendChild(codeElement)

    this.element.prepend(parElement, preElement)
  }
}
