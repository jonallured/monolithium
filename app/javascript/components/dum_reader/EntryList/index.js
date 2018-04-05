import React from "react"

import EntryItem from "components/dum_reader/EntryItem"

const EntryList = ({ entries }) => {
  const entryItems = entries.map(entry => <EntryItem {...entry} />)
  return <div>{entryItems}</div>
}

export default EntryList
