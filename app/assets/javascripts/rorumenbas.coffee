# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.rorumenba-table').DataTable({
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    "aoColumnDefs": [
        { "bSortable": false, "aTargets": [ 5,6 ]},
        {
            "targets": [5,6],
            "width": '5%'
        }
    ],
    "columnDefs": [ {
        "targets"  : 'no-sort',
        "orderable": false
    }]
    ,"oSearch": {"sSearch": queryParameters().search}
  })

  $('#rorumenba').click () ->
     shainNo = []
     selected_rows = shain_table.rows( { selected: true } ).data()
     for row in selected_rows
       shainNo.push(row[1])
     $('#shain').val(shainNo.toString())

  shain_table = $('.shain-table').DataTable({
    "pagingType": "simple_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
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
