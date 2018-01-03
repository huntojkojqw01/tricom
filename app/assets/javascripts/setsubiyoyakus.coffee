# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oTable = $('.setsubiyoyaku-table').DataTable({
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "aoColumnDefs": [
        { "bSortable": false, "aTargets": [ 6,7 ]},
        {
            "targets": [6,7],
            "width": '7%'
        },
        {
          "targets": 0,
          "visible": false
        }
    ],
    "columnDefs": [ {
        "targets"  : 'no-sort',
        "orderable": false
    }],
    "oSearch": {"sSearch": queryParameters().search},
    "buttons": [{
            "extend":    'copyHtml5',
            "text":      '<i class="fa fa-files-o"></i>',
            "titleAttr": 'Copy',
            "exportOptions": {
                "columns": [1,2,3,4,5]
            }
        },
        {
            "extend":    'excelHtml5',
            "text":      '<i class="fa fa-file-excel-o"></i>',
            "titleAttr": 'Excel',
            "exportOptions": {
                "columns": [1,2,3,4,5]
            }
        },
        {
            "extend":    'csvHtml5',
            "text":      '<i class="fa fa-file-text-o"></i>',
            "titleAttr": 'CSV',
            "exportOptions": {
                "columns": [1,2,3,4,5]
            }
        },
        {
                "extend":    'import',
                "text":      '<i class="glyphicon glyphicon-import"></i>',
                "titleAttr": 'Import'
            },
        {
          "extend": 'selectAll',
          "action": ( e, dt, node, config )->
            oTable.$('tr').addClass('selected')
            oTable.$('tr').addClass('success')
            selects = oTable.rows('tr.selected').data()
            if (selects.length == 0)
              $("#destroy_setsubiyoyaku").attr("disabled", true)
            else
              $("#destroy_setsubiyoyaku").attr("disabled", false)
            $(".buttons-select-none").removeClass('disabled')

        },
        {
          "extend": 'selectNone',
          "action": ( e, dt, node, config )->
            oTable.$('tr').removeClass('selected')
            oTable.$('tr').removeClass('success')
            selects = oTable.rows('tr.selected').data()
            if( selects.length == 0)
              $("#destroy_setsubiyoyaku").attr("disabled", true)
            else
              $("#destroy_setsubiyoyaku").attr("disabled", false)
            $(".buttons-select-none").addClass('disabled')
        }
      ]
  })
  $("#destroy_setsubiyoyaku").addClass("disabled");
  $('.setsubiyoyaku-table').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_eki").addClass("disabled");
        # $("#destroy_eki").addClass("disabled");
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_eki").removeClass("disabled");
        # $("#destroy_eki").removeClass("disabled");
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#destroy_setsubiyoyaku").addClass("disabled");
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_setsubiyoyaku").removeClass("disabled");
      $(".buttons-select-none").removeClass('disabled')


  )

  $('#destroy_setsubiyoyaku').click () ->
    setsubiyoyakus = oTable.rows('tr.selected').data()
    setsubiyoyakuIds = new Array();
    if setsubiyoyakus.length == 0
      swal($('#message_confirm_select').text())
    else

      swal({
        title: $('#message_confirm_delete').text(),
        text: "",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "OK",
        cancelButtonText: "キャンセル",
        closeOnConfirm: false,
        closeOnCancel: false
      }).then(() ->
        len = setsubiyoyakus.length
        for i in [0...len]
          setsubiyoyakuIds[i] = setsubiyoyakus[i][0]

        $.ajax({
          url: '/setsubiyoyakus/ajax',
          data:{
            focus_field: 'setsubiyoyaku_削除する',
            setsubiyoyakus: setsubiyoyakuIds
          },

          type: "POST",

          success: (data) ->
            swal("削除されました!", "", "success");
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              oTable.rows('tr.selected').remove().draw()
            else
              console.log("getAjax destroy_success:"+ data.destroy_success)


          failure: () ->
            console.log("setsubiyoyaku_削除する keydown Unsuccessful")

        })
        $("#destroy_setsubiyoyaku").addClass("disabled");

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#destroy_setsubiyoyaku").addClass("disabled");
          else
            $("#destroy_setsubiyoyaku").removeClass("disabled");
      );
  $('#export_setsubiyoyaku').click ()->
    location.href='/setsubiyoyakus/export_csv.csv?locale=ja'
  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
#    calendarWeeks: true,
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
  $('#kaisha-table-modal').on( 'dblclick', 'tr', ()->
    $(this).addClass('selected')
    $(this).addClass('success')
    d = oKaishaTable.row('tr.selected').data()
    $('#setsubiyoyaku_相手先').val d[0]
    $('.hint-kaisha-refer').text(d[1])
    $('#kaisha-search-modal').modal('hide')
  )
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

    if getUrlVars()["all_day"] == "true"
      $("#select_allday").prop('checked', true);
    else
      $("#select_allday").prop('checked', false);
  $('#head_setsubicode').change ()->
    $(this).closest('form').submit()

  $('#hide_table_button').click () ->
    $('#hide_table_button').hide()
    $('#show_table_button').show()
    $('#table-div').hide()

  $('#show_table_button').click () ->
    $('#hide_table_button').show()
    $('#show_table_button').hide()
    $('#table-div').show()

  $("#select_allday").change ->
    date = moment().format("YYYY/MM/DD");

    if getUrlVars()["start_at"]!= undefined && getUrlVars()["start_at"]!=""
      date = getUrlVars()["start_at"];
    if $('#time_start').text() != ''
      date = $('#time_start').text()[0..9]
    date = date.split("/").join("-")
    if $(this).is(":checked")
      $('#setsubiyoyaku_開始').val(moment(date+" 00:00").format("YYYY/MM/DD HH:mm"))
      $('#setsubiyoyaku_終了').val(moment(date+" 24:00").format("YYYY/MM/DD HH:mm"))
    else
      $('#setsubiyoyaku_開始').val(moment(date+" 09:00").format("YYYY/MM/DD HH:mm"))
      $('#setsubiyoyaku_終了').val(moment(date+" 18:00").format("YYYY/MM/DD HH:mm"))
