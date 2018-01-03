# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  shokairan_table = $('.shokairan-table').DataTable({
    "pagingType": "simple_numbers"
    "fnDrawCallback": (oSettings) ->
      $('.new-btn').appendTo($('.dt-buttons'));
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    columnDefs: [
      { "width": "15%", "targets": 0 },
      { "width": "10%", "targets": 1 },
      { "width": "20%", "targets": 2 },
      { "width": "50%", "targets": 3 },
      { "width": "5%", "targets": 4 }
    ],
    buttons: [
      'selectAll',
      'selectNone'
    ],
    order: [[ 0, 'des' ]]
  })

  kairan_table = $('.kairan-table').DataTable({
    "pagingType": "simple_numbers"
    "fnDrawCallback": (oSettings) ->
      $('.new-btn').appendTo($('.dt-buttons'));
      $('.edit-btn').appendTo($('.dt-buttons'));
#      $('.kakunin-btn').appendTo($('.dt-buttons'));
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },

    columnDefs: [
      { orderable: false,className: 'select-checkbox',targets: 7},
      { "width": "12%", "targets": 0 },
      { "width": "12%", "targets": 1 },
      { "width": "13%", "targets": 2 },
      { "width": "13%", "targets": 2 },
      { "width": "15%", "targets": 3 },
      { "width": "6%", "targets": 5 },
      { "width": "6%", "targets": 6 },
      { "width": "5%", "targets": 7 },
      { "targets": [ 8 ], "visible": false, "searchable": false },
      { "targets": [ 9 ], "visible": false, "searchable": false },
      { "targets": [ 10 ], "visible": false, "searchable": false },
    ],
    select: {
      style:    'multi',
      selector: 'td:last-child'
    },
    order: [[ 0, 'des' ]],
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    buttons: [
      'selectAll',
      'selectNone'
    ],
    "oSearch": {"sSearch": queryParameters().search}
  })

  shain_table = $('.shain-table').DataTable({
    "pagingType": "simple_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "pageLength" : 20,
    columnDefs: [ {
      orderable: false,
      className: 'select-checkbox',
      targets:   0
    } ],
    select: {
      style:    'multi',

    },
    dom: 'Bfrtip',
    buttons: [
      'selectAll',
      'selectNone'
    ]
  })

  $('#kakunin').addClass('disabled')
  kairan_table.on( 'select', ( e, dt, type, indexes )->
    row = kairan_table[ type ]( indexes ).nodes().to$()
    data = kairan_table.row( indexes ).data()
    if data[10] != $('#session_user').val()
      kairan_table.row( indexes ).nodes().to$().removeClass( 'selected' );
      swal("あなたはアクセス権限ではありません！")
    else if data[5] == '確認済'
      kairan_table.row( indexes ).nodes().to$().removeClass( 'selected' );
      swal("確認済!")

  );
  $('.kairan-table tbody').on( 'click', 'tr', () ->
    d = kairan_table.row('tr.selected').data()
    if d!= undefined
      $('#kakunin').removeClass('disabled')
    else
      $('#kakunin').addClass('disabled')
  )

  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
#    calendarWeeks: false,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
#    defaultDate: '2016/03/14 09:00'
  })

  $('#kairan_開始').click () ->
    $('.kairan_開始 .datetime').data("DateTimePicker").toggle();
  $('#kairan_終了').click () ->
    $('.kairan_終了 .datetime').data("DateTimePicker").toggle();

  $('#kairan').click (e) ->
    selected_rows = shain_table.rows( { selected: true } ).data()
    shainNo = []
    for row in selected_rows
      shainNo.push(row[1])
    $('#shain').val(shainNo.toString())
    if $('#kairan_開始').val() == ''
      today = new Date
      DD = today.getDate()
      MM = today.getMonth() + 1
      YYYY = today.getFullYear()
      HH = today.getHours()
      mm = today.getMinutes()
      if DD < 10
        DD = '0' + DD
      if MM < 10
        MM = '0' + MM
      if HH< 10
        HH = '0' + HH
      if mm < 10
        mm = '0' + mm
      today = YYYY + '/' + MM + '/' + DD + ' '+HH+':'+mm
      $("#kairan_開始").val(today)
    if $('#kairan_件名').val() == ''
      e.preventDefault()
      swal("件名を入力してください。")
    if $('#shain').val() == ''
      e.preventDefault()
      swal("社員を選択してください。")

  $('#kakunin').click () ->
    selected_rows = kairan_table.rows( { selected: true } ).data()
    kairanNo = []
    for row in selected_rows
      kairanNo.push(row[8])
    $('#checked').val(kairanNo.toString())

  getTaishoList = (arrData) ->
    result = []
    for subdata in arrData
      strData = "[id='"+subdata.対象者+"']"
      result.push(strData)
    return result

  send_kairan_id = $('#send_kairan_id').val()
  getPath = '/kairans/'+send_kairan_id+'/send_kairan_view'
  $.getJSON(getPath, (data) ->
    shain_table_mark = $('.shain-table-mark').DataTable({
      "pagingType": "simple_numbers",
      "oLanguage":{
        "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
      },
      "select": {
        "style": 'multi'
      },
      "columns": [
        { "data": '社員番号' },
        { "data": '社員名' }
      ],
      "rowId": '社員番号',
      "initComplete": ( settings ) ->
        api = new $.fn.dataTable.Api( settings )
        api.rows(getTaishoList(data.taishosha)).select()
    })
  )
