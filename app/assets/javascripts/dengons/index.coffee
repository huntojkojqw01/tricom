jQuery ->
	$('.dengon').DataTable
    pagingType: "simple_numbers"
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
    dom: "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    aoColumnDefs: [
      { "bSortable": false, "aTargets": [ 10,11]},
      {
        "targets": [10,11],
        "width": '5%',
        "targets": [7],
        "width": '20%'
      }
    ]
    columnDefs: [
      "targets": 'no-sort',
      "orderable": false
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
          window.location = '/dengons/new'
      }
    ]
    oSearch:
      sSearch: queryParameters().search
    order: [[2, "desc"]]
