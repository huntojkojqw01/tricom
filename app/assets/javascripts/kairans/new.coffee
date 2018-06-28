jQuery ->
  shain_table = $('.shain-table').DataTable
    pagingType: "simple_numbers",
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
    pageLength : 20,
    columnDefs: [ {
      orderable: false,
      className: 'select-checkbox',
      targets:   0
    } ]
    select:
      style:    'multi'
    dom: 'Bfrtip'
    buttons: [
      'selectAll',
      'selectNone'
    ]

  $('.datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false

  $('#kairan_開始').click ()->
    $('.kairan_開始 .datetime').data("DateTimePicker").toggle()
  $('#kairan_終了').click ()->
    $('.kairan_終了 .datetime').data("DateTimePicker").toggle()

  $('#kairan').click (e) ->
    selected_rows = shain_table.rows( { selected: true } ).data()
    shainNo = []
    for row in selected_rows
      shainNo.push(row[1])
    $('#shain').val(shainNo.toString())
    if $('#kairan_件名').val() == ''
      e.preventDefault()
      swal("件名を入力してください。")
    if $('#shain').val() == ''
      e.preventDefault()
      swal("社員を選択してください。")
