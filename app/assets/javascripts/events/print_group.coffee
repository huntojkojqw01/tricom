jQuery ->
  reset_start_end_date = ()->
    currentDate = new Date
    startOfWeek = moment().startOf('isoweek').format('YYYY/MM/DD')
    endOfWeek = moment().endOf('isoweek').format('YYYY/MM/DD')
    $('#date_start_input').val startOfWeek
    $('#date_end_input').val endOfWeek

  $('.date_start_select').datetimepicker format: 'YYYY/MM/DD'
  $('.date_end_select').datetimepicker format: 'YYYY/MM/DD'
  $('#date_start_input').click ->
    $('.date_start_select').data("DateTimePicker").toggle()
  $('#date_end_input').click ->
    $('.date_end_select').data("DateTimePicker").toggle()

  reset_start_end_date()
  $('#print_group button').click ->
    $('#print_group button:disabled').prop('disabled', false)
    $(this).prop('disabled', true)
    $('#selectDay').show()
    reset_start_end_date()

  $('#print_pdf').click ->
    switch $('#print_group button:disabled').attr('id')
      when 'pdf_event'
        action = 'pdf_event_show'
      when 'pdf_job'
        action = 'pdf_job_show'
      when 'pdf_koutei'
        action = 'pdf_koutei_show'
    window.open('/events/' + action + '.pdf?locale=ja&date_start=' + $("#date_start_input").val() + '&date_end=' + $("#date_end_input").val())
