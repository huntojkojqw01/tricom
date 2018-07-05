jQuery ->
  $('.datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false

  $('#setsubiyoyaku_開始').click ->
    $('.setsubiyoyaku_開始 .datetime').data("DateTimePicker").toggle()
  $('#setsubiyoyaku_終了').click ->
    $('.setsubiyoyaku_終了 .datetime').data("DateTimePicker").toggle()

  $("#select_allday").change ->
    date = moment().format("YYYY/MM/DD")
    if getUrlVars()["start_at"] != undefined && getUrlVars()["start_at"] != ''
      date = getUrlVars()["start_at"]
    if $('#time_start').text() != ''
      date = $('#time_start').text()[0..9]
    date = date.split("/").join("-")
    if $(this).is(":checked")
      $('#setsubiyoyaku_開始').val(moment(date+" 00:00").format("YYYY/MM/DD HH:mm"))
      $('#setsubiyoyaku_終了').val(moment(date+" 24:00").format("YYYY/MM/DD HH:mm"))
    else
      $('#setsubiyoyaku_開始').val(moment(date+" 09:00").format("YYYY/MM/DD HH:mm"))
      $('#setsubiyoyaku_終了').val(moment(date+" 18:00").format("YYYY/MM/DD HH:mm"))

  $('.refer-kaisha').click ()->
    $('#kaisha-search-modal').trigger('show', [$('#setsubiyoyaku_相手先').val()])

  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#setsubiyoyaku_相手先').val(selected_data[0])
      $('.hint-kaisha-refer').text(selected_data[1])
      $('#setsubiyoyaku_相手先').closest('.form-group').find('span.help-block').remove()
      $('#setsubiyoyaku_相手先').closest('.form-group').removeClass('has-error')

  setup_tab_render_name
    input: $('#setsubiyoyaku_相手先')
    output: $('.hint-kaisha-refer')
    table: $('#kaisha-table-modal')