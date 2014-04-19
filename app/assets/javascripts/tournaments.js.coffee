# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # tournament#show page
  if ($('#tournament').length)
    # Tournament creation
    createBracket = ->
      d = new $.Deferred
      $('#tournament').bracket({
        skipConsolationRound: gon.skip_consolation_round,
        skipSecondaryFinal: gon.skip_secondary_final,
        init: gon.tournament_data
      })
      d.resolve()

    hideDecimal = ->
      jQuery.each($('.score'), ->
        if !isNaN(this.innerText)
          if $.inArray(this.innerText, ["0.2", "0.3"]) >= 0  # Hide score on bye match
            this.innerText = '--'
          else
            this.innerText = Math.floor(this.innerText)
      )

    addCountryFlg = ->
      jQuery.each(gon.countries, (i, v) ->
        if this.length
          console.log $('.team').eq(i)
          $('.bracket .team').eq(i).find('.label').prepend('<div class="flag-container f16"><div class="flag '+this+'"></div>')
      )
    createBracket().done(hideDecimal(), addCountryFlg())


    # Show game info on hover
    $('.teamContainer').attr({
      'data-toggle': 'tooltip',
      'data-placement': 'right',
    })
    $('.teamContainer').each (i) ->
      $('.teamContainer').eq(i).attr('title', gon.match_data[i])
    $('.teamContainer').tooltip({html:true})


  # tournament#edit page - Tags input
  if $('#tournament_tag_list').length
    $('#tournament_tag_list').tagsInput({'width':'100%', 'height':'auto'})
