import React from 'react'
import { EntryItem } from '../EntryItem'
import { Entry } from '../../shared/Entry'

interface EntryListProps {
  entries: Entry[]
}

export const EntryList: React.FC<EntryListProps> = props => {
  const entryItems = props.entries.map((entry, i) => {
    return <EntryItem key={i} entry={entry} />
  })

  return <div>{entryItems}</div>
}
