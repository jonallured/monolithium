import React from "react"
import ReactDOM from "react-dom"
import { Reader } from "../apps/DumReader/shared/Reader"
import { DumReader } from "../apps/DumReader"

declare global {
  interface Window {
    reader: Reader
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const root = document.getElementById("root")
  const reader = new Reader()
  window.reader = reader
  ReactDOM.render(<DumReader reader={reader} />, root)
})
