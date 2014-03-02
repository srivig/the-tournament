# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  tournament_data = {
    teams : [
      ["Team 1", "Team 2"],
      ["Team 3", "Team 4"]
    ],
    results : [[
      [[1,2], [3,4]],
      [[5,6]]
    ], [
      [[7,8]],
      [[9,10]]
    ], [
      [[1,12], [13,14]],
      [[15,16]]
    ]]
  }


  createBracket = ->
    d = new $.Deferred
    $('#tournament').bracket(init: tournament_data)
    d.resolve()

  hideDecimal = ->
    jQuery.each($('.score'), ->
      this.innerText = Math.floor(this.innerText)
    )

  createBracket().done(hideDecimal())
