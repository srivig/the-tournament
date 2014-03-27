$(document).on 'page:fetch', ->
  $('body').spin({length:12,width:5})
$(document).on 'page:change', ->
  $('body').spin(false)

