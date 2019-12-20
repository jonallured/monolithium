import Entry from './Entry'

test('it defaults to not selected', () => {
  const entry = new Entry({})
  expect(entry.selected).toBe(false)
})
