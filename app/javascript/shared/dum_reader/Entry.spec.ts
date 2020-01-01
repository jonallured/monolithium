import { Entry } from './Entry'

describe('defaults', () => {
  it('starts off un selected', () => {
    const entry = new Entry({})
    expect(entry.selected).toBe(false)
  })
})
