# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.game_game_records_score input').change ->
    # どっちもスコア入ってるかチェック
    scores = [$('.game_game_records_score input')[0].value, $('.game_game_records_score input')[1].value]
    if scores[0] && scores[1]
      # 点数比較して勝者を決定
      if scores[0] > scores[1]
        winner = 0
      else if scores[0] < scores[1]
        winner = 1
      else
        winner = 2

      # formの値とdivのclassをセット(負けた方のをリセット)
      winner_inputs = $('.game_game_records_winner input')
      winner_inputs[0].value = winner_inputs[1].value = ""
      # divのclassをセット
      $('.panel').removeClass('panel-danger').addClass('panel-default')

      # 引き分けじゃなかったら勝者セット
      if winner != 2
        $('.game_game_records_winner input')[winner].value = true
        $('.game_game_records_winner input')[1-winner].value = false
        $('.panel').eq(winner).addClass('panel-danger')

