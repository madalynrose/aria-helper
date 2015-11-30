Constants = require '../constants/aria-helper.coffee'

difference = require 'lodash/array/difference'
union = require 'lodash/array/union' 

Immutable = require 'immutable'

initialState =
  ariaData: []
  status: 'LOADED'
  expanded: []
  minimized: []
  selectedAttribute: ""

module.exports.ariaHelper = (state, action) ->
  state = initialState unless state?
  expanded = state.expanded
  minimized = state.minimized
  state = Immutable.fromJS state

  switch action.type
    when Constants.GET_ARIA_DATA
      state = state.merge
        promise: action.payload
        status: 'PENDING'
    when Constants.ARIA_DATA_LOADED
      state = state.merge
        promise: undefined
        status: 'LOADED'
        ariaData: action.payload
    when Constants.ARIA_DATA_ERROR
      state = state.merge
        promise: undefined
        status: 'ERROR'
    when Constants.TOGGLE_EXPANDER
      if expanded? and action.payload in expanded
        newExpanded = difference(expanded, [action.payload])
        state = state.merge
          expanded: newExpanded 
      else
        if expanded?
          newExpanded = union(expanded, [action.payload])  
          state = state.merge
            expanded: newExpanded
        else
          state = state.merge
            expanded: [action.payload] 
    when Constants.TOGGLE_MINIMIZER
      if minimized? and action.payload in minimized
        newMinimized = difference(minimized, [action.payload])
        state = state.merge 
          minimized: newMinimized
      else
        if minimized?
          newMinimized = union(minimized, [action.payload])
          state = state.merge
            minimized: newMinimized
        else
          state = state.merge
            minimized: [action.payload] 
    when Constants.SELECT_ATTRIBUTE
      state = state.merge
        selectedAttribute: action.payload
    else
      return state.toJS()

  return state.toJS()