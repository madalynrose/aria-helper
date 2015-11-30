React            = require 'react'
{ Component }    = React

{ RouteHandler, Link } = require 'react-router'

class Page extends Component

  constructor: (props) ->
    super props

  render: ->
    <div>
      <Link to="/">Aria Helper</Link>
      <div><RouteHandler /></div>
    </div>

module.exports = Page
