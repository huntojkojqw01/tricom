# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.bashokubunmsttable').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
    ,"aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 2,3 ]},
      {
        "targets": [2,3],
        "width": '5%'
      }
    ],
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
  })
