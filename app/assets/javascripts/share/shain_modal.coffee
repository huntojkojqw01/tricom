jQuery ->
  create_sentaku_modal
    modal: $('#select_user_modal')
    table: $('#user_table')
    clear_button: $('#clear_shain')
    ok_button: $('#user_sentaku_ok')
    trigger_name: 'choose_shain'
    invisible_columns: [2, 3]
    no_search_columns: [2, 3]