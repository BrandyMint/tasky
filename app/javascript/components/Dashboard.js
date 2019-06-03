import React from "react"
import PropTypes from "prop-types"
import Board from 'react-trello'

class Dashboard extends React.Component {
  render () {
    return <Board data={this.props.data} draggable editable addLaneMode leanDraggable/>
  }
}

export default Dashboard
