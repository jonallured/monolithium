import { DumReader } from './DumReader'

const refreshNoop = jest.fn()

describe('App', () => {
  it('sets initial state', () => {
    const props = { reader: { entries: [], refresh: refreshNoop } }
    const app = new DumReader(props)

    expect(app.state).toEqual({
      entries: props.reader.entries,
      fade: false,
      help: 'hidden',
      notice: null,
    })
  })
})
