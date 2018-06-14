jQuery ->
  modal = $('#select_user_modal_refer')
  table = $('#user_table')
  ok_button = $('#user_refer_sentaku_ok')
  clear_button = $('#clear_shain')
  trigger_name = 'choose_shain'

  create_sentaku_modal(modal, table, ok_button, clear_button, trigger_name)
