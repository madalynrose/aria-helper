# ## Example of a component which needs data.
React         = require 'react'
{ Component, PropTypes } = React
actions = require '../actions/aria-helper'

{ connect } = require 'react-redux'
{ bindActionCreators } = require 'redux'

class AriaHelper extends Component

  # The `initialData` method returns a Promise. It needs to be resolved
  # before the route renders.
  @initialData: (state) ->
    promise = state.dispatch(actions.getAriaData()).payload
    return promise

  @propTypes:
    ariaData: PropTypes.object.isRequired
    actions: PropTypes.object
    expanded: PropTypes.array
    minimized: PropTypes.array
    selectedAttribute: PropTypes.string


  constructor: (props) ->
    super props
    @state =
      expanded: []
      ariaData: {}
      minimized: []
      selectedAttribute: ""

  render: ->
    <div id="aria-helper">
      <div id="roles">
        ROLES
        {@renderMinimizer("role")}
        {if !@isMinimized("role") then @renderAll("role")}
      </div>
      <div id="states">
        STATES
        {@renderMinimizer("state")}
        {if !@isMinimized("state") then @renderAll("state")}
      </div>

      <div id="properties">
        PROPERTIES 
        {@renderMinimizer("property")}
        {if !@isMinimized("property") then @renderAll("property")}
      </div>
    </div>


  renderAll: (attributeType) ->
    allAttributes = {}
    switch attributeType
      when "role"
        allAttributes = @props.ariaData.roles
      when "state"
        allAttributes = @props.ariaData.states
      when "property"
        allAttributes = @props.ariaData.properties
    <ul>
    {
      for name, attr of allAttributes
        @renderAttribute(attr, attributeType)
    }
    </ul>

  renderAttribute: (attr, type) ->
    switch type
      when "role"
        @renderRole(attr)
      when "state"
        @renderState(attr)
      when "property"
        @renderProperty(attr)

  renderMinimizer: (type) ->
     <span className="minimize-#{type}s" onClick={@_onClickMinimize}>{if @isMinimized(type) then "[+]" else "[-]"}</span>

  renderRole: (role) ->
    <li className="role" key={role.name} onClick={@_onClickAttribute}>{role.name}</li>

  isMinimized: (type) ->
    return "minimize-#{type}s" in @props.minimized 

  renderState: (state) ->
    expanded = state.name in @props.expanded
    <li className="state" key={state.name}>
      {state.name} <span className="expand #{state.name}" onClick={@_onClickExpand}>+</span>
      {
        if expanded
          for n, v of state.valueDescriptions
            @renderValueDescription(n,v)
      }
    </li>

  renderProperty: (property) ->
    expanded = property.name in @props.expanded
    hasValueDescriptions = Object.keys(property.valueDescriptions).length > 0
    <li className="property" key={property.name}>
      {property.name} 
      {if hasValueDescriptions then <span className="expand #{property.name}" onClick={@_onClickExpand}>+</span>}
      {
        if expanded
          for n, v of property.valueDescriptions
            @renderValueDescription(n,v)
      }
    </li>

  renderValueDescription: (name, value) ->
    <div className='value-description' key={name}>
      <span className="value-name">{name}: </span><span className="value-description">{value}</span>
    </div>

  _onClickExpand: (e) => 
    @props.actions.toggleExpander(e.target.classList[1])

  _onClickAttribute: (e) =>
    @props.actions.selectAttribute(e.target.innerHTML)

  _onClickMinimize:(e) =>
    @props.actions.toggleMinimizer(e.currentTarget.className)

mapStateToProps = (state) ->
  {
    ariaData: state.ariaHelper.ariaData
    expanded: state.ariaHelper.expanded
    minimized: state.ariaHelper.minimized
    selectedAttribute: state.ariaHelper.selectedAttribute
  }

mapDispatchToProps = (dispatch) -> 
  actions: bindActionCreators actions, dispatch

# We use connect from react-redux to connect the data.
module.exports = connect(mapStateToProps, mapDispatchToProps) AriaHelper
