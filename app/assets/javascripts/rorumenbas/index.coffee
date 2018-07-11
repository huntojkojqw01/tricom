jQuery ->
  $('.rorumenba-table').DataTable
    pagingType: "full_numbers"
    dom: "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>"
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
    aoColumnDefs: [
        { "bSortable": false, "aTargets": [ 5,6 ]},
        {
          "targets": [5,6],
          "width": '5%'
        }
    ]
    columnDefs: [ {
        "targets"  : 'no-sort',
        "orderable": false
    }]
    oSearch:
      sSearch: queryParameters().search
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
          window.location = '/rorumenbas/new'
      }
    ]
