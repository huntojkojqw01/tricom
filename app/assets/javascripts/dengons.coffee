# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
#    calendarWeeks: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
  })

  $('#dengon_日付').click () ->
    $('.datetime').data("DateTimePicker").toggle();

  oDengon = $('.dengon').DataTable({
    "pagingType": "simple_numbers"
    "fnDrawCallback": (oSettings) ->
      $('.new-btn').appendTo($('.dt-buttons'));
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 10,11]},
      {
        "targets": [10,11],
        "width": '5%',
        "targets": [7],
        "width": '20%'
      }
      ],
    columnDefs: [
      "targets": 'no-sort',
      "orderable": false
    ],
    buttons: [
      'selectAll',
      'selectNone'
    ],
    "oSearch": {"sSearch": queryParameters().search},
    "order": [[ 2, "desc" ]]
  })

  $('#dengon_touroku').click (e) ->
    if $('#dengon_from1').val() == '' && $('#dengon_from2').val() == '' && $('#dengon_日付').val() == ''&& $('#dengon_社員番号').val() == ''&& $('#dengon_用件').val() == '' && $('#dengon_回答').val() == ''&& $('#dengon_伝言内容').val() == ''
      e.preventDefault()
      swal("入力してください。")
