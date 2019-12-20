import React from 'react'
import styled from 'styled-components'
import colors from '../../../shared/dum_reader/colors'

const EntryRow = styled.dl`
  background-color: ${props =>
    props.selected ? colors.highlight : colors.white};
  border-bottom: 1px solid ${colors.lightGray};
  margin: 0;

  a {
    color: ${props => props.color};
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

const EntryItem = ({ date, feedTitle, selected, status, title, url }) => {
  const color = statusColorMap[status]

  return (
    <EntryRow
      selected={selected}
      color={color}
      className={selected ? 'selected' : ''}
    >
      <a href={url} target="_blank">
        <FeedName>{feedTitle}</FeedName>
        <EntryDate>{date}</EntryDate>
        <dt>{title}</dt>
      </a>
    </EntryRow>
  )
}

export default EntryItem
