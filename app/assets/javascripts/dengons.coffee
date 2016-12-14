# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    calendarWeeks: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
  })

  oDengon = $('.dengon').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
    ,"aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 10,11]},
      {
        "targets": [10,11],
        "width": '5%',
        "targets": [7],
        "width": '20%'
      }
    ],
    "columnDefs": [{
      "targets": 'no-sort',
      "orderable": false
    }]
  })