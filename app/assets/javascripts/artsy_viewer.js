window.onload = () => {
  const mainElement = document.querySelector('main')
  const mainStyles = window.getComputedStyle(mainElement)
  const heightProperty = mainStyles.getPropertyValue('height')
  const heightValue = heightProperty.split("px")[0] - 1

  const ArtsyViewer = {
    artworks: [],
    elements: {
      main: mainElement
    },
    heightValue,
  }

  App.ArtsyViewer = ArtsyViewer

  App.cable.subscriptions.create('ArtsyViewerChannel', {
    received: (data) => {
      if (App.ArtsyViewer.artworks.length === data.length) return

      App.ArtsyViewer.artworks = data

      ArtsyViewer.elements.main.replaceChildren()

      const [first, ...rest] = ArtsyViewer.artworks

      rest.forEach(artwork => {
        const { blurb, href, image } = artwork.payload

        const blurbNode = document.createTextNode(blurb)
        const parElement = document.createElement("p")
        parElement.appendChild(blurbNode)

        const footerElement = document.createElement("footer")
        footerElement.appendChild(parElement)

        const imageElement = document.createElement("img")
        const widthValue = (ArtsyViewer.heightValue - 70) * image.aspect_ratio
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
      })

      const { blurb, href, image } = first.payload

      const blurbNode = document.createTextNode(blurb)
      const parElement = document.createElement("p")
      parElement.appendChild(blurbNode)

      const footerElement = document.createElement("footer")
      footerElement.appendChild(parElement)

      const imageElement = document.createElement("img")
      const imageHeight = ArtsyViewer.heightValue - 70
      const widthValue = imageHeight * image.aspect_ratio
      const widthProperty = `${widthValue}px`

      imageElement.src = image.url
      imageElement.style.height = `${imageHeight}px`
      imageElement.style.width = widthProperty
      imageElement.classList.add("collapsed")
      imageElement.classList.add("hidden")

      const aElement = document.createElement("a")
      const url = `https://www.artsy.net${href}`

      aElement.href = url

      aElement.appendChild(imageElement)
      aElement.appendChild(footerElement)

      const sectionElement = document.createElement("section")
      sectionElement.appendChild(aElement)

      ArtsyViewer.elements.main.prepend(sectionElement)

      setTimeout(() => {
        imageElement.classList.remove("collapsed")
        setTimeout(() => {
          imageElement.classList.remove("hidden")
        }, 500)
      }, 500)
    }
  })
}
