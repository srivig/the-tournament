# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if(typeof gon != 'undefined')
    createBracket = ->
      d = new $.Deferred
      $('#tournament').bracket(init: gon.tournament_data)
      d.resolve()

    hideDecimal = ->
      jQuery.each($('.score'), ->
        if !isNaN(this.innerText)
          this.innerText = Math.floor(this.innerText)
      )

    createBracket().done(hideDecimal())

