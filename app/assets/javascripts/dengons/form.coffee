jQuery ->
  $('.datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false

  $('#dengon_日付').click () ->
    $('.datetime').data("DateTimePicker").toggle()

  $('#dengon_touroku').click (e) ->
    if $('#dengon_from1').val() == '' || $('#dengon_from2').val() == '' || $('#dengon_日付').val() == '' || $('#dengon_社員番号').val() == '' || $('#dengon_用件').val() == '' || $('#dengon_回答').val() == '' || $('#dengon_伝言内容').val() == ''
      e.preventDefault()
      swal("入力してください。")