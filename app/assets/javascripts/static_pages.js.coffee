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

  if $('#tournament-sample').length
    sample = {
      "teams": [["ヨルダン", "アラブ首長国連邦"], ["オーストラリア", "サウジアラビア"], ["シリア", "韓国"], ["イラク", "日本"]],
      "results": [[[1, 0], [1, 2], [1, 2], [1, 0]], [[1, 3], [0, 1]], [[1, 0], [3, 2]]]
    }
    createBracket = ->
      d = new $.Deferred
      $('#tournament-sample').bracket(init: sample)
      d.resolve()

    hideDecimal = ->
      jQuery.each($('.score'), ->
        if !isNaN(this.innerText)
          if $.inArray(this.innerText, [0.2, 0.3]) >= 0
            this.innerText = '--'
          this.innerText = Math.floor(this.innerText)
      )

    createBracket().done(hideDecimal())


