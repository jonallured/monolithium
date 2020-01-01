import React from 'react'
import styled from 'styled-components'
import { colors } from '../../../shared/dum_reader/colors'
import { Entry } from '../../../shared/dum_reader/Entry'

const EntryRow = styled.dl`
  background-color: ${(props): string =>
    props.selected ? colors.highlight : colors.white};
  border-bottom: 1px solid ${colors.lightGray};
  margin: 0;

  a {
    color: ${(props): void => props.color};
    display: block;
    padding: 10px;
    text-decoration: none;
  }

  dd {
    margin: 0;
  }

  dt {
    margin-left: 200px;
  }
`

const FeedName = styled.dd`
  float: left;
  width: 200px;
`

const EntryDate = styled.dd`
  float: right;
  text-align: right;
  width: 80px;
`

const statusColorMap = {
  archived: colors.darkGray,
  saved: colors.red,
  unread: colors.black,
}

interface EntryItemProps {
  entry: Entry
}

export const EntryItem: React.FC<EntryItemProps> = props => {
  const { date, feedTitle, selected, status, title, url } = props.entry
  const color = statusColorMap[status]

  return (
    <EntryRow
      className={selected ? 'selected' : ''}
      color={color}
      selected={selected}
    >
      <a href={url} target="_blank" rel="noopener noreferrer">
        <FeedName>{feedTitle}</FeedName>
        <EntryDate>{date}</EntryDate>
        <dt>{title}</dt>
      </a>
    </EntryRow>
  )
}
