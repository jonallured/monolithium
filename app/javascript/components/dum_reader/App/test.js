import React from 'react'
import { configure, mount } from 'enzyme'
import Entry from '../../../shared/dum_reader/Entry'
import App from './index'

const refreshNoop = () => {}

describe('App', () => {
  it('sets initial state', () => {
    const props = { reader: { entries: [], refresh: refreshNoop } }
    const app = new App(props)

    expect(app.state).toEqual({
      entries: props.reader.entries,
      fade: false,
      help: 'hidden',
      notice: null,
    })
  })

  it('clears notice and fade on transition end', () => {
    const props = { reader: { entries: [], refresh: refreshNoop } }
    const app = mount(<App {...props} />).instance()

    app.handleTransitionEnd()

    expect(app.state.notice).toEqual(null)
    expect(app.state.fade).toEqual(false)
  })

  it("computes props for it's children", () => {
    const entries = [new Entry({ id: 123 })]
    const timestamp = 'right now'
    const props = {
      reader: { entries: entries, timestamp: timestamp, refresh: refreshNoop },
    }
    const app = mount(<App {...props} />).instance()

    const {
      helpProps,
      headerProps,
      mainProps,
      footerProps,
    } = app.computeProps()

    expect(helpProps).toEqual({
      closeHelp: app.closeHelp,
      visibility: 'hidden',
    })
    expect(headerProps).toEqual({ openHelp: app.openHelp })
    expect(mainProps).toEqual({ entries: entries })
    expect(footerProps).toEqual({
      count: entries.length,
      notice: null,
      fade: false,
      timestamp: timestamp,
    })
  })
})
