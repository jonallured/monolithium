import { App } from './index'

const refreshNoop = jest.fn()

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
})
