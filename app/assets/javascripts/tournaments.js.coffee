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
          useCORS: true,
          onrendered: (canvas) ->
            canvasImage = canvas.toDataURL("image/png", 1.0)
            $("#download_btn").attr('href', canvasImage).attr('download', 'tournament.png')
            $("#btn-upload_img").attr('data-img_uri', canvasImage)
            $("#download_btn, #btn-upload_img").button("reset")
        })
      , 1500

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
    $("#download_btn, #btn-upload_img").button('loading')

  # tournament#edit page - Tags input
  if $('#tournament_tag_list').length
    $('#tournament_tag_list').tagsInput({'width':'100%', 'height':'auto'})


  # tournament#photos
  if ($('body').data('controller')=='tournaments' && $('body').data('action')=='photos')
    if gon.album_id != null
      window.fbAsyncInit = ->
        FB.init({
          appId      : '1468816573143230',
          xfbml      : true,
          version    : 'v2.8'
        })
        FB.AppEvents.logPageView()

        request_url = "/" + gon.album_id + "/photos?fields=images&access_token=" + gon.fb_token
        FB.api request_url, (response) ->
          photos = ''
          album_url = "https://www.facebook.com/media/set/?set=a." + gon.album_id
          $.each response.data, (index, obj) ->
            return false if index >= 12

            start_div = end_div = ''
            if index%4 == 0
              start_div = '<div class="row" style="margin-bottom:15px;">'
            if index%4 == 3 || index == response.data.length
              end_div = '</div>'
            photos += start_div + '<div class="col-sm-3"><a href="' + album_url + '" target="_blank"><div style="width:100%;height:200px;background-size:cover;background-position:center;background-image:url('+obj.images[0]['source']+')"></div></a></div>' + end_div
          $('.album-container').append(photos)
