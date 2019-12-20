import React from 'react'
import EntryItem from '../EntryItem'

const EntryList = ({ entries }) => {
  const entryItems = entries.map(entry => <EntryItem {...entry} />)
  return <div>{entryItems}</div>
}

export default EntryList
