jQuery ->
  oTable = $('#yakushoku_table').DataTable({
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 2,3 ]},
      {"targets": [2,3],"width": '5%'}
    ],
    "columnDefs": [{
      "targets"  : 'no-sort',
      "orderable": false
    }]
  })