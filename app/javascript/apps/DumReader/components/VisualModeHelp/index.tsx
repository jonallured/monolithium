import React from 'react'
import styled from 'styled-components'

const Wrapper = styled.table`
  td {
    vertical-align: top;
  }
  td.key {
    text-align: right;
  }
  td.action {
    padding-left: 10px;
  }
`

export const VisualModeHelp: React.FC = () => (
  <Wrapper>
    <tbody>
      <tr>
        <td className="key">v</td>
        <td className="action">toggle Visual Mode</td>
      </tr>
      <tr>
        <td className="key">&lt;esc&gt;</td>
        <td className="action">leave Visual Mode</td>
      </tr>
      <tr>
        <td className="key">j</td>
        <td className="action">move selection down</td>
      </tr>
      <tr>
        <td className="key">k</td>
        <td className="action">move selection up</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td className="key">a</td>
        <td className="action">archive entries</td>
      </tr>
      <tr>
        <td className="key">s</td>
        <td className="action">save entries for later</td>
      </tr>
      <tr>
        <td className="key">u</td>
        <td className="action">mark entries as unread</td>
      </tr>
    </tbody>
  </Wrapper>
)
