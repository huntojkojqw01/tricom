jQuery ->
  $('.shokairan-table').DataTable
    pagingType: "simple_numbers"
    oLanguage:
      sUrl: "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    dom: "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    columnDefs: [
      { "width": "15%", "targets": 0 },
      { "width": "10%", "targets": 1 },
      { "width": "20%", "targets": 2 },
      { "width": "50%", "targets": 3 },
      { "width": "5%", "targets": 4 }
    ]
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
    ],
    order: [[ 0, 'des' ]]
