import React from "react"
import ReactDOM from "react-dom"

import Reader from "shared/dum_reader/Reader"
import App from "components/dum_reader/App"

document.addEventListener("DOMContentLoaded", () => {
  const root = document.getElementById("root")
  const reader = new Reader()

  window._reader = reader

  ReactDOM.render(<App reader={reader} />, root)
})
