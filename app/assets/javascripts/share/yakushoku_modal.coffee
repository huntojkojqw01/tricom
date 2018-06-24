jQuery ->
  modal = $('#select_yakushoku_modal')
  table = $('#yakushoku_search_table')
  ok_button = $('#yakushoku_ok')
  clear_button = $('#clear_yakushoku')
  trigger_name = 'choose_yakushoku'

  create_sentaku_modal(modal, table, ok_button, clear_button, trigger_name)
