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

const NormalModeHelp = () => (
  <Wrapper>
    <tbody>
      <tr>
        <td className="key">j</td>
        <td className="action">move down entry list</td>
      </tr>
      <tr>
        <td className="key">k</td>
        <td className="action">move up entry list</td>
      </tr>
      <tr>
        <td className="key">gg</td>
        <td className="action">jump to top of entry list</td>
      </tr>
      <tr>
        <td className="key">G</td>
        <td className="action">jump to bottom of entry list</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td className="key">&lt;return&gt;</td>
        <td className="action">open entry in new tab</td>
      </tr>
      <tr>
        <td className="key">a</td>
        <td className="action">archive entry</td>
      </tr>
      <tr>
        <td className="key">s</td>
        <td className="action">save entry for later</td>
      </tr>
      <tr>
        <td className="key">u</td>
        <td className="action">mark entry as unread</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td className="key">g + a</td>
        <td className="action">go to archived entries</td>
      </tr>
      <tr>
        <td className="key">g + s</td>
        <td className="action">go to saved entries</td>
      </tr>
      <tr>
        <td className="key">g + u</td>
        <td className="action">go to unread entries</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td className="key">v</td>
        <td className="action">toggle Visual Mode</td>
      </tr>
      <tr>
        <td className="key">r</td>
        <td className="action">reload page</td>
      </tr>
      <tr>
        <td className="key">?</td>
        <td className="action">view this help message</td>
      </tr>
      <tr>
        <td className="key">&lt;esc&gt;</td>
        <td className="action">dismiss help message</td>
      </tr>
    </tbody>
  </Wrapper>
)

export default NormalModeHelp
