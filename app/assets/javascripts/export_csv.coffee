jQuery ->
  export_table = $('.export-table').DataTable({
    "pagingType": "simple_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    },
#    "aoColumnDefs": [
#      { "bSortable": false, "aTargets": [0]},
#      {
#        "targets": [0],
#        "width": '20%'
#      }
#    ],
#    "columnDefs": [{
#      "targets"  : 'no-sort',
#      "orderable": false
#    }],
    columnDefs: [ {
      orderable: false,
      className: 'select-checkbox',
      targets:   0
    } ],
    select: {
#      style:    'os',
      style:    'multi',
#      selector: 'td:first-child'
    },
    order: [[ 1, 'asc' ]],
    dom: 'Bfrtip',
    buttons: [
#      'selected',
#      'selectedSingle',
      'selectAll',
      'selectNone'
#      'selectRows',
#      'selectColumns',
#      'selectCells'
    ]
  })

  $('#export-csv').click () ->
    selected_rows = export_table.rows( { selected: true } ).data()
    shainNo = []
    for row in selected_rows
      shainNo.push(row[1])
    $('#export').val(shainNo.toString())

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
        "sUrl": "../../assets/resource/dataTable_ja.txt"
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
