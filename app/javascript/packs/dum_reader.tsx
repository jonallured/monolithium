import React from 'react'
import ReactDOM from 'react-dom'
import { Reader } from '../shared/dum_reader/Reader'
import { App } from '../components/dum_reader/App'

declare global {
  interface Window {
    reader: Reader
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const root = document.getElementById('root')
  const reader = new Reader()
  window.reader = reader
  ReactDOM.render(<App reader={reader} />, root)
})
