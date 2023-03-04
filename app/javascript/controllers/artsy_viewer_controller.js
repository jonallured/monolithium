import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  initialize() {
    const Notification = window.Notification || {}
    const mainElement = this.element
    mainElement.className = 'flex gap-1 justify-between item-end h-screen font-artsy text-lg mx-1'
    const mainStyles = window.getComputedStyle(mainElement)
    const heightProperty = mainStyles.getPropertyValue("height")
    const heightValue = heightProperty.split("px")[0] - 1

    const ArtsyViewer = {
      artworks: [],
      heightValue,
      notificationPermission: Notification.permission,
      notifications: [],
    }

    this.ArtsyViewer = ArtsyViewer

    const channelName = "ArtsyViewerChannel"
    const eventHandlers = {
      received: this.handleReceived.bind(this)
    }

    consumer.subscriptions.create(channelName, eventHandlers)
  }

  handleReceived(data) {
    if (this.ArtsyViewer.artworks.length === data.length) return

    if (this.ArtsyViewer.notificationPermission === "granted") {
      this.ArtsyViewer.notifications.forEach((staleNotification) => {
        staleNotification.close()
      })

      const newNotification = new Notification("new artwork!")
      this.ArtsyViewer.notifications.push(newNotification)
    }

    this.element.replaceChildren()
    this.ArtsyViewer.artworks = data
    this.ArtsyViewer.artworks.slice(0, 2).forEach(this.drawSection.bind(this))
    this.drawPanel()
  }

  drawPanel() {
    const isGranted = this.ArtsyViewer.notificationPermission === "granted"
    const message = isGranted ? "Notify: yes" : "Notify: no"
    const textNode = document.createTextNode(message)
    const parElement = document.createElement("p")
    parElement.appendChild(textNode)

    const asideElement = document.createElement("aside")
    asideElement.className = 'h-screen ml-4 min-w-[300px] pl-4 border-l-8 border-dark-gray text-black'
    asideElement.appendChild(parElement)

    if (Notification.requestPermission && !isGranted) {
      const linkParElement = this.createLink()
      asideElement.appendChild(linkParElement)
    }

    this.element.appendChild(asideElement)
  }

  createLink() {
    const textNode = document.createTextNode("turn on")
    const aElement = document.createElement("a")
    aElement.className = "no-underline text-black hover:text-black hover:underline"
    aElement.href = "#"
    aElement.addEventListener("click", (event) => {
      event.preventDefault()
      Notification.requestPermission()
    })
    aElement.appendChild(textNode)

    const parElement = document.createElement("p")
    parElement.appendChild(aElement)

    return parElement
  }

  drawSection(artwork, index) {
    const { blurb, href, image } = artwork.payload

    const blurbNode = document.createTextNode(blurb)
    const parElement = document.createElement("p")
    parElement.className = "line-clamp-1 m-0"
    parElement.appendChild(blurbNode)

    const footerElement = document.createElement("footer")
    footerElement.className = "mt-4"
    footerElement.appendChild(parElement)

    const imageElement = document.createElement("img")
    imageElement.className = "max-w-none m-0"

    if (index === 0) {
      imageElement.classList.add("!w-0")
      imageElement.classList.add("opacity-0")

      setTimeout(() => {
        imageElement.classList.remove("!w-0")
        setTimeout(() => {
          imageElement.classList.remove("opacity-0")
        }, 500)
      }, 1000)
    }

    const heightValue = this.ArtsyViewer.heightValue - 60
    const heightProperty = `${heightValue}px`

    const widthValue = heightValue * image.aspect_ratio
    const widthProperty = `${widthValue}px`

    imageElement.src = image.url
    imageElement.style.height = heightProperty
    imageElement.style.width = widthProperty
    imageElement.style.transition = "width 300ms ease-in-out, opactity 200ms ease-in-out"

    const aElement = document.createElement("a")
    const url = `https://www.artsy.net${href}`

    aElement.href = url
    aElement.className = "no-underline text-black hover:text-black"

    aElement.appendChild(imageElement)
    aElement.appendChild(footerElement)

    const sectionElement = document.createElement("section")
    sectionElement.appendChild(aElement)

    this.element.appendChild(sectionElement)
  }
}
