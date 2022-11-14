window.onload = () => {
  const Notification = window.Notification || {}
  const mainElement = document.querySelector('main')
  const mainStyles = window.getComputedStyle(mainElement)
  const heightProperty = mainStyles.getPropertyValue('height')
  const heightValue = heightProperty.split("px")[0] - 1

  const ArtsyViewer = {
    artworks: [],
    elements: { main: mainElement },
    heightValue,
    notificationPermission: Notification.permission,
    notifications: []
  }

  App.ArtsyViewer = ArtsyViewer

  const drawSection = (artwork, index) => {
    const { blurb, href, image } = artwork.payload

    const blurbNode = document.createTextNode(blurb)
    const parElement = document.createElement("p")
    parElement.appendChild(blurbNode)

    const footerElement = document.createElement("footer")
    footerElement.appendChild(parElement)

    const imageElement = document.createElement("img")

    if (index === 0) {
      imageElement.classList.add("collapsed")
      imageElement.classList.add("hidden")

      setTimeout(() => {
        imageElement.classList.remove("collapsed")
        setTimeout(() => {
          imageElement.classList.remove("hidden")
        }, 500)
      }, 500)
    }

    const imageHeight = ArtsyViewer.heightValue - 70
    const widthValue = imageHeight * image.aspect_ratio
    const widthProperty = `${widthValue}px`

    imageElement.src = image.url
    imageElement.style.width = widthProperty

    const aElement = document.createElement("a")
    const url = `https://www.artsy.net${href}`

    aElement.href = url

    aElement.appendChild(imageElement)
    aElement.appendChild(footerElement)

    const sectionElement = document.createElement("section")
    sectionElement.appendChild(aElement)

    ArtsyViewer.elements.main.appendChild(sectionElement)
  }

  const createLink = () => {
    const textNode = document.createTextNode("turn on")
    const aElement = document.createElement("a")
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

  const drawPanel = () => {
    const isGranted = ArtsyViewer.notificationPermission === 'granted'
    const message = isGranted ? 'Notify: yes' : 'Notify: no'
    const textNode = document.createTextNode(message)
    const parElement = document.createElement("p")
    parElement.appendChild(textNode)

    const asideElement = document.createElement("aside")
    asideElement.appendChild(parElement)

    if (Notification.requestPermission && !isGranted) {
      const linkParElement = createLink()
      asideElement.appendChild(linkParElement)
    }

    ArtsyViewer.elements.main.appendChild(asideElement)
  }

  App.cable.subscriptions.create('ArtsyViewerChannel', {
    received: (data) => {
      if (ArtsyViewer.artworks.length === data.length) return

      if (ArtsyViewer.notificationPermission === 'granted') {
        ArtsyViewer.notifications.forEach(staleNotification => {
          staleNotification.close()
        })

        const newNotification = new Notification('new artwork!')
        ArtsyViewer.notifications.push(newNotification)
      }

      ArtsyViewer.elements.main.replaceChildren()
      ArtsyViewer.artworks = data
      ArtsyViewer.artworks.forEach(drawSection)
      drawPanel()
    }
  })
}
