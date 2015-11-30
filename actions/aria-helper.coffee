Constants = require '../constants/aria-helper.coffee'

Api = require '../services/Api.coffee'

module.exports.getAriaData = -> (dispatch) ->
  action = dispatch
    type: Constants.GET_ARIA_DATA
    payload: Api.get 'http://localhost:8000/api/aria-helper'

  action.payload
    .then (ariaData) -> dispatch
      type: Constants.ARIA_DATA_LOADED
      payload: ariaData
    .catch -> dispatch
      type: Constants.ARIA_DATA_ERROR

module.exports.selectAttribute = (selectedAttribute) -> (dispatch) ->
  action = dispatch
    type: Constants.SELECT_ATTRIBUTE
    payload: selectedAttribute

module.exports.toggleExpander = (attributeName) -> (dispatch) ->
  action = dispatch
    type: Constants.TOGGLE_EXPANDER
    payload: attributeName


module.exports.toggleMinimizer = (className) -> (dispatch) ->
  action = dispatch
    type: Constants.TOGGLE_MINIMIZER
    payload: className