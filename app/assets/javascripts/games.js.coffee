# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#game-edit').length
    # 同点の場合は最初から手動の勝者選択をactiveにしとく
    scores = [Number($('.game_game_records_score input')[0].value), Number($('.game_game_records_score input')[1].value)]
    if scores[0] == scores[1]
      enable_winner_select()

    # スコアが変更されたとき
    $('.game_game_records_score input').change ->
      scores = [Number($('.game_game_records_score input')[0].value), Number($('.game_game_records_score input')[1].value)]
      # 点数比較して勝者を決定
      winner = judge_winner(scores[0], scores[1])
      reset_winner()

      # 引き分けじゃなかったら勝者セット
      if winner
        set_winner(winner)
        disable_winner_select()
      # 引き分けのときは手動で勝者選択できるようにする
      else
        enable_winner_select()

    # 手動の勝者選択が変更されたとき
    $('#winner-select').change ->
      reset_winner()
      # 2人のうちのどちらかが選ばれていたら
      if $.inArray($(this).val(), ["1","2"]) >= 0
        winner = $(this).val()
        set_winner(winner)

# スコアから勝者を判定
judge_winner = (score_1, score_2) ->
  winner = null
  if score_1 > score_2
    winner = 1
  else if score_1 < score_2
    winner = 2
  return winner

# formの値とdivのclassをリセット
reset_winner = ->
  $('.game_game_records_winner input').attr('value', '')
  $('.panel').removeClass('panel-warning').addClass('panel-default')
  $('.panel-heading i').removeClass('icon-trophy icon-remove')

# winner/loserの要素をそれぞれセット
set_winner = (winner) ->
  $('.game_game_records_winner input')[winner-1].value = true
  $('.game_game_records_winner input')[2-winner].value = false
  $('.panel').eq(winner-1).addClass('panel-warning')
  $('.panel-heading i').eq(winner-1).addClass('icon-trophy')
  $('.panel-heading i').eq(2-winner).addClass('icon-remove')

# 手動の勝者選択を可能にする
enable_winner_select = ->
  $('#winner-select').removeAttr('disabled')

# 手動の勝者選択を不可にして設定値をリセット
disable_winner_select = ->
  $('#winner-select').attr('disabled','disabled')
  $('#winner-select').val('0')
