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
    createBracket().done(hideDecimal(), addCountryFlg())


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
    html2canvas($(".bracket"), {
      onrendered: (canvas) ->
        canvasImage = canvas.toDataURL("image/jpeg")
        $("#download_btn").attr('href', canvasImage)
        $("#download_btn").button("reset")
    })

  # Update embeded tournament
  $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
    alert "埋め込みトーナメントが更新されました！"
  $("a[data-remote]").on "ajax:error", (e, xhr, status, error) ->
    alert "更新に失敗しました。。何回か試しても機能しない場合は、お手数ですが運営までお問い合わせください。"

  # tournament#edit page - Tags input
  if $('#tournament_tag_list').length
    $('#tournament_tag_list').tagsInput({'width':'100%', 'height':'auto'})
