$(document).on 'page:fetch', ->
  top = $(window).height()/2 + $(window).scrollTop()
  $('body').spin({length:12,width:5,top:top})
$(document).on 'page:change', ->
  $('body').spin(false)

