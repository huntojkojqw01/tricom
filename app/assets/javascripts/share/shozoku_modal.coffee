jQuery ->
  modal = $('#select_shozoku_modal')
  table = $('#shozoku_search_table')
  ok_button = $('#shozoku_ok')
  clear_button = $('#clear_shozoku')
  trigger_name = 'choose_shozoku'

  create_sentaku_modal(modal, table, ok_button, clear_button, trigger_name)
