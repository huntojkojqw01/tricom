jQuery ->
  modal = $('#kaisha-search-modal')
  table = $('#kaisha-table-modal')
  ok_button = $('#kaisha_sentaku_ok')
  clear_button = $('#clear_kaisha')
  trigger_name = 'choose_kaisha'

  create_sentaku_modal(modal, table, ok_button, clear_button, trigger_name)
