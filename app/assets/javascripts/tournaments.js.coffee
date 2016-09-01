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
          else if gon.scoreless   # when the tournament is scoreless
            this.innerText = '--'
          else  # Same score win
            this.innerText = Math.floor(this.innerText)
      )

    addCountryFlg = ->
      jQuery.each(gon.countries, (i, v) ->
        if v
          $('.bracket .team').eq(i).find('.label').prepend('<div class="flag-container f16"><div class="flag '+v+'"></div>')
      )

    prepareImage = ->
      setTimeout ->
        html2canvas($(".bracket"), {
          onrendered: (canvas) ->
            canvasImage = canvas.toDataURL("image/jpeg")
            canvasImage = canvasImage.replace(/^data:image\/jpeg/, "data:application/octet-stream");
            $("#download_btn").attr('href', canvasImage).attr('download', 'tournament.jpg')
            $("#download_btn").button("reset")
        })
      , 15000

    createBracket().done(hideDecimal(), addCountryFlg(), prepareImage())


    # Show game info on hover
    $('.teamContainer').attr({
      'data-toggle': 'tooltip',
      'data-placement': 'right',
    })
    $('.bracket .teamContainer').each (i) ->
      $('.bracket .teamContainer').eq(i).attr('title', gon.match_data[1][i])
    if $('.loserBracket').length
      $('.loserBracket .teamContainer').each (i) ->
        $('.loserBracket .teamContainer').eq(i).attr('title', gon.match_data[2][i])
      $('.finals .teamContainer').each (i) ->
        $('.finals .teamContainer').eq(i).attr('title', gon.match_data[3][i])
    $('.teamContainer').tooltip({html:true})

    # Image Download
    $("#download_btn").button('loading')

  # tournament#edit page - Tags input
  if $('#tournament_tag_list').length
    $('#tournament_tag_list').tagsInput({'width':'100%', 'height':'auto'})
