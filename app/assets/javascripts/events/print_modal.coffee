jQuery ->
  reset_start_end_date = ()->
    currentDate = new Date
    startOfWeek = moment().startOf('isoweek').format('YYYY/MM/DD')
    endOfWeek = moment().endOf('isoweek').format('YYYY/MM/DD')
    $('#modal_date_start_input').val startOfWeek
    $('#modal_date_end_input').val endOfWeek

  $('.modal_date_start_select').datetimepicker format: 'YYYY/MM/DD'
  $('.modal_date_end_select').datetimepicker format: 'YYYY/MM/DD'
  $('#modal_date_start_input').click ->
    $('.modal_date_start_select').data("DateTimePicker").toggle()
  $('#modal_date_end_input').click ->
    $('.modal_date_end_select').data("DateTimePicker").toggle()

  $('#print_modal li').click ->
    $('#print_modal li.active').removeClass('active')
    $(this).addClass('active')
    reset_start_end_date()

  $('#print_pdf').click ->
    switch $('#print_modal li.active').attr('id')
      when 'modal_pdf_event'
        action = 'pdf_event_show'
      when 'modal_pdf_job'
        action = 'pdf_job_show'
      when 'modal_pdf_koutei'
        action = 'pdf_koutei_show'
    window.open('/events/' + action + '.pdf?locale=ja&date_start=' + $("#modal_date_start_input").val() + '&date_end=' + $("#modal_date_end_input").val())
