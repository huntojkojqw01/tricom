# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.setsubiyoyaku-table').DataTable({
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
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
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  $('#kaisha-table-modal tbody').on 'click', 'tr', (event) ->
    d = oKaishaTable.row(this).data()
    # $('#setsubiyoyaku_相手先').val(d[0])
    # $('.hint-kaisha-refer').text(d[1])
    # $('#kaisha-name').text(d[1])

    if $(this).hasClass('selected')
      $(this).removeClass 'selected'
      $(this).removeClass 'success'
      $('#kaisha_sentaku_ok').attr 'disabled', true
      $('#clear_kaisha').attr 'disabled', true
      # $('#setsubiyoyaku_相手先').val ''
      # $('#kaisha-name').text ''
    else
      oKaishaTable.$('tr.selected').removeClass 'selected'
      oKaishaTable.$('tr.success').removeClass 'success'
      $(this).addClass 'selected'
      $(this).addClass 'success'
      $('#kaisha_sentaku_ok').attr 'disabled', false
      $('#clear_kaisha').attr 'disabled', false

  $('#clear_kaisha').click () ->
    # $('#setsubiyoyaku_相手先').val('');
    # $('.hint-kaisha-refer').text('');
    $('#setsubiyoyaku_相手先').closest('.form-group').find('span.help-block').remove();
    $('#setsubiyoyaku_相手先').closest('.form-group').removeClass('has-error');
    oKaishaTable.$('tr.selected').removeClass 'selected'
    oKaishaTable.$('tr.success').removeClass 'success'
    $('#kaisha_sentaku_ok').attr 'disabled', true
    $('#clear_kaisha').attr 'disabled', true
  $('#kaisha_sentaku_ok').on 'click', ->
    d = oKaishaTable.row('tr.selected').data()
    $('#setsubiyoyaku_相手先').val d[0]
    $('.hint-kaisha-refer').text(d[1])
  $('.refer-kaisha').click ->
    $('#kaisha-search-modal').modal 'show'
    if $('#setsubiyoyaku_相手先').val() != ''
      oKaishaTable.rows().every (rowIdx, tableLoop, rowLoop) ->
        data = @data()
        if data[0] == $('#setsubiyoyaku_相手先').val()
          oKaishaTable.$('tr.selected').removeClass 'selected'
          oKaishaTable.$('tr.success').removeClass 'success'
          @nodes().to$().addClass 'selected'
          @nodes().to$().addClass 'success'
      oKaishaTable.page.jumpToData $('#setsubiyoyaku_相手先').val(), 0
      $('#kaisha_sentaku_ok').attr 'disabled', false
      $('#clear_kaisha').attr 'disabled', false
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

  $("#select_allday").change ->
    if $(this).is(":checked")
      $('#setsubiyoyaku_開始').val(moment(getUrlVars()["start_at"]+" 00:00").format("YYYY/MM/DD HH:mm"))
      $('#setsubiyoyaku_終了').val(moment(getUrlVars()["start_at"]+" 24:00").format("YYYY/MM/DD HH:mm"))
    else
      $('#setsubiyoyaku_開始').val(moment(getUrlVars()["start_at"]+" 09:00").format("YYYY/MM/DD HH:mm"))
      $('#setsubiyoyaku_終了').val(moment(getUrlVars()["start_at"]+" 18:00").format("YYYY/MM/DD HH:mm"))