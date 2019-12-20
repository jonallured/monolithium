import React from 'react'
import ReactDOM from 'react-dom'

import App from 'components/App'
import Router from 'shared/Router'

document.addEventListener('DOMContentLoaded', () => {
  const token = (document.querySelector('meta[name=csrf-token]') || {}).content
  const router = new Router(token)

  const props = {
    projects,
    router,
  }

  ReactDOM.render(<App {...props} />, document.getElementById('root'))
})
