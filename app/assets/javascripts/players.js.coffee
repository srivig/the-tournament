# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#member-list').length
    $("#csv-btn").bind "change", (e) ->
      alert(hoge) for hoge in e.target.files
