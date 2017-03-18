$ ->
  # user/show
  if($('body').data('controller')=='users' && $('body').data('action')=='show')
    window.fbAsyncInit = ->
      FB.init({
        appId      : '1468816573143230',
        xfbml      : true,
        version    : 'v2.8'
      })
      FB.AppEvents.logPageView()

      request_url = "/" + gon.fb_id + "?fields=cover&access_token=" + gon.fb_token
      FB.api request_url, (response) ->
        $('.cover').css('background-image', "url('"+response.cover.source+"')").show()
      # FB.api "/1450405358327365/photos?fields=images&access_token=1468816573143230|RXVAmkE2kAYW4P8h_e8fBf8T4kc", (response) ->
      #   console.log(response)
