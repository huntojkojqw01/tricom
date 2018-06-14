jQuery ->
  modal = $('#job_search_modal')
  table = $('#job_table')
  ok_button = $('#job_sentaku_ok')
  clear_button = $('#clear_job')
  trigger_name = 'choose_job'

  create_sentaku_modal(modal, table, ok_button, clear_button, trigger_name)
