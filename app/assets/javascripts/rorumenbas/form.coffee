jQuery ->
  $('#rorumenba').click ()->
     shainNo = []
     selected_rows = shain_table.rows( { selected: true } ).data()
     for row in selected_rows
       shainNo.push(row[1])
     $('#shain').val(shainNo.toString())

  $('.shain-table').DataTable
    pagingType: "simple_numbers"
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
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
