# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  nav_height = 70

  $('a[href^=#]').click ->
    speed = 500
    href= $(this).attr("href")
    # target = $(href == "#" || href == "" ? 'html' : href)
    target = $(href)
    position = target.offset().top - nav_height
    $("html, body").animate({scrollTop:position}, speed, "swing")
    return false

