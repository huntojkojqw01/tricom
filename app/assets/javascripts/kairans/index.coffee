jQuery ->
  kairan_table = $('.kairan-table').DataTable
    pagingType: "simple_numbers"
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
    columnDefs: [
      { orderable: false, className: 'select-checkbox', targets: 7 },
      { width: "12%", targets: 0 },
      { width: "12%", targets: 1 },
      { width: "13%", targets: 2 },
      { width: "13%", targets: 2 },
      { width: "15%", targets: 3 },
      { width: "6%", targets: 5 },
      { width: "6%", targets: 6 },
      { width: "5%", targets: 7 },
      { targets: [8, 9, 10], visible: false, searchable: false }
    ]
    select:
      style:    'multi'
      selector: 'td:last-child'
    order: [[ 0, 'des' ]]
    dom: "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    buttons: [
      {
          extend: 'selectAll'
          attr:
            id: 'all'
          action: (e, dt, node, config)->
            dt.rows().select()
        },
        {
          extend: 'selectNone'
          attr:
            id: 'none'
          action: (e, dt, node, config)->
            dt.rows().deselect()
        },
        {
          text: '新規'
          attr:
            id: 'new'
          action: (e, dt, node, config)->
            window.location = '/kairans/new'
        },
        {
          text: '送信一覧'
          attr:
            id: 'send_kairan'
          action: (e, dt, node, config)->
            window.location = '/kairans/shokairan'
        }
    ]
    oSearch:
    	sSearch: queryParameters().search

  $('#kakunin').addClass('disabled')
  kairan_table.on 'select', (e, dt, type, indexes)->
    row = kairan_table[ type ]( indexes ).nodes().to$()
    data = kairan_table.row( indexes ).data()
    if data[10] != $('#session_user').val()
      kairan_table.row( indexes ).nodes().to$().removeClass( 'selected' )
      swal("あなたはアクセス権限ではありません！")
    else if data[5] == '確認済'
      kairan_table.row( indexes ).nodes().to$().removeClass( 'selected' )
      swal("確認済!")

  $('.kairan-table tbody').on 'click', 'tr', ()->
    d = kairan_table.row('tr.selected').data()
    if d != undefined
      $('#kakunin').removeClass('disabled')
    else
      $('#kakunin').addClass('disabled')

  $('#kakunin').click ()->
    selected_rows = kairan_table.rows( { selected: true } ).data()
    kairanNo = []
    for row in selected_rows
      kairanNo.push(row[8])
    $('#checked').val(kairanNo.toString())
