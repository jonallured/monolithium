// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree .

const tenMinutesInMS = 600000
const params = new URLSearchParams(window.location.search)

const ArtsyViewer = {
  artworks: [],
  currentIndex: 0,
  tags: {},
  viewTime: params.get("viewTime") || tenMinutesInMS,
}

const getNextArtwork = () => {
  if (ArtsyViewer.currentIndex === ArtsyViewer.artworks.length) {
    ArtsyViewer.currentIndex = 0
  }

  const nextArtwork = ArtsyViewer.artworks[ArtsyViewer.currentIndex]
  ArtsyViewer.currentIndex += 1

  return nextArtwork
}

const updateSection = (section) => {
  const artwork = getNextArtwork()

  const image = artwork.images[0]
  const imageUrl = image.image_urls.normalized
  const widthValue = ArtsyViewer.heightValue * image.aspect_ratio
  const widthProperty = `${widthValue}px`

  section.imageTag.src = imageUrl
  section.imageTag.style.width = widthProperty

  section.sectionTag.style.width = widthProperty
  section.footerTag.style.width = widthProperty
  section.parTag.textContent = artwork.display
}

const hideFirstFooter = () => {
  ArtsyViewer.tags.firstSection.footerTag.classList.add('hide')
  ArtsyViewer.tags.lastSection.footerTag.classList.remove('hide')

  updateSection(ArtsyViewer.tags.lastSection)
}

const hideSecondFooter = () => {
  ArtsyViewer.tags.lastSection.footerTag.classList.add('hide')
  ArtsyViewer.tags.firstSection.footerTag.classList.remove('hide')

  updateSection(ArtsyViewer.tags.firstSection)
}

const sendFirstToBack = () => {
  ArtsyViewer.tags.firstSection.sectionTag.classList.add("back")
  ArtsyViewer.tags.lastSection.sectionTag.classList.remove("back")

  setTimeout(hideSecondFooter, ArtsyViewer.viewTime / 2)
  setTimeout(sendLastToBack, ArtsyViewer.viewTime)
}

const sendLastToBack = () => {
  ArtsyViewer.tags.firstSection.sectionTag.classList.remove("back")
  ArtsyViewer.tags.lastSection.sectionTag.classList.add("back")

  setTimeout(hideFirstFooter, ArtsyViewer.viewTime / 2)
  setTimeout(sendFirstToBack, ArtsyViewer.viewTime)
}

const getSection = (sectionTag) => {
  return {
    footerTag: sectionTag.querySelector('footer'),
    imageTag: sectionTag.querySelector('img'),
    parTag: sectionTag.querySelector('p'),
    sectionTag: sectionTag,
  }
}

const setupArtsyViewer = () => {
  ArtsyViewer.tags.main = document.querySelector('main')
  const [firstSection, lastSection] = document.getElementsByTagName('section')
  ArtsyViewer.tags.firstSection = getSection(firstSection)
  ArtsyViewer.tags.lastSection = getSection(lastSection)
  const mainStyles = window.getComputedStyle(ArtsyViewer.tags.main)
  const heightProperty = mainStyles.getPropertyValue('height')
  const heightValue = heightProperty.split("px")[0] - 1
  ArtsyViewer.heightValue = heightValue

  hideSecondFooter()
  sendLastToBack()
}

const createSub = () => {
  App.cable.subscriptions.create('ArtsyViewerChannel', {
    received: (data) => {
      ArtsyViewer.artworks = data
      setupArtsyViewer()
    }
  })
}

window.onload = createSub
