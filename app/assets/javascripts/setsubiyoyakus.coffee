# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.setsubiyoyaku-table').DataTable({
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
    "aoColumnDefs": [
        { "bSortable": false, "aTargets": [ 5,6 ]},
        {
            "targets": [5,6],
            "width": '7%'
        }
    ],
    "columnDefs": [ {
        "targets"  : 'no-sort',
        "orderable": false
    }]
  })

  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    calendarWeeks: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
#    defaultDate: '2016/03/14 09:00'
  })

  oKaishaTable = $('#kaisha-table-modal').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
  })

  $('#kaisha-table-modal tbody').on 'click', 'tr', (event) ->
    d = oKaishaTable.row(this).data()
    $('#setsubiyoyaku_相手先').val(d[0])
    $('#kaisha-name').text(d[1])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKaishaTable.$('tr.selected').removeClass('selected')
      oKaishaTable.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $(document).on 'click', '.refer-kaisha', (event) ->
    $('#kaisha-search-modal').modal('show')
    event.preventDefault()

  $(document).ready () ->
    if $('#head_setsubicode').val() != ''
      $('#table-div').hide()
      $('#hide_table_button').hide()
    else
      $('#setsubiyoyaku-timeline').hide()
      $('#table-div').hide()
      $('#hide_table_button').hide()
      $('#show_table_button').hide()

  $('#hide_table_button').click () ->
    $('#hide_table_button').hide()
    $('#show_table_button').show()
    $('#table-div').hide()

  $('#show_table_button').click () ->
    $('#hide_table_button').show()
    $('#show_table_button').hide()
    $('#table-div').show()

