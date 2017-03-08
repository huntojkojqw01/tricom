# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $(document).ready () ->
    keihi_pdf = getUrlVars()["keihiheadId"];
    if keihi_pdf != '' && keihi_pdf != undefined
      window.open('/keihiheads/pdf_show.pdf?locale=ja&keihiheadId=' +keihi_pdf)
  $(document).on 'click', '.keihihead-update', (event) ->
    summary()
  $(document).on 'click', '.summary', (event) ->
    summary()
  $("#destroy_keihihead").attr("disabled", true);
#  sonotha_sum, koutsuhi_sum, nittou_sum, shukuhaku_sum, shinsheino
  summary = () ->
    sonotha_sum = 0
    koutsuhi_sum = 0
    nittou_sum = 0
    shukuhaku_sum = 0

    $('.koutsuhi').each( () ->
      value = $(this).val()
      if(!isNaN(value) && value.length != 0)
        koutsuhi_sum += parseFloat(value)
    )

    $('.nittou').each( () ->
      value = $(this).val()
      if(!isNaN(value) && value.length != 0)
        nittou_sum += parseFloat(value)
    )

    $('.shukuhaku').each( () ->
      value = $(this).val()
      if(!isNaN(value) && value.length != 0)
        shukuhaku_sum += parseFloat(value)
    )

    $('.sonotha').each( () ->
#    //var value = $(this).text()
      value = $(this).val()
#    // add only if the value is number
      if(!isNaN(value) && value.length != 0)
        sonotha_sum += parseFloat(value)
    )

    hansikin = $('#keihihead_仮払金').val()
    shikyuhin = $('#keihihead_支給品').val()

    if(!isNaN(hansikin) && hansikin.length != 0) then hansikin = $('#keihihead_仮払金').val() else hansikin = 0

    if(!isNaN(shikyuhin) && shikyuhin.length != 0) then shikyuhin = $('#keihihead_支給品').val() else shikyuhin = 0

#    //minue value for checked remove
    _sonotha_sum = 0
    _koutsuhi_sum = 0
    _nittou_sum = 0
    _shukuhaku_sum = 0
    $('.check-remove').each( () ->
      if ($(this).val() == "1")
        value = $(this).closest('tr').find('.koutsuhi').val()
        if(!isNaN(value) && value.length != 0)
          _koutsuhi_sum += parseFloat(value)

        value = $(this).closest('tr').find('.nittou').val()
        if(!isNaN(value) && value.length != 0)
          _nittou_sum += parseFloat(value)

        value = $(this).closest('tr').find('.shukuhaku').val()
        if(!isNaN(value) && value.length != 0)
          _shukuhaku_sum += parseFloat(value)

        value = $(this).closest('tr').find('.sonotha').val()
        if(!isNaN(value) && value.length != 0)
          _sonotha_sum += parseFloat(value)
    )

    koutsuhi_sum -= _koutsuhi_sum
    nittou_sum -= _nittou_sum
    shukuhaku_sum -= _shukuhaku_sum
    sonotha_sum -= _sonotha_sum

    $('#keihihead_交通費合計').val(koutsuhi_sum)
    $('#keihihead_日当合計').val(nittou_sum)
    $('#keihihead_宿泊費合計').val(shukuhaku_sum)
    $('#keihihead_その他合計').val(sonotha_sum)
    $('#keihihead_旅費合計').val(koutsuhi_sum + nittou_sum + shukuhaku_sum)
    $('#keihihead_合計').val(koutsuhi_sum + nittou_sum + shukuhaku_sum + sonotha_sum)
    $('#keihihead_過不足').val(koutsuhi_sum + nittou_sum + shukuhaku_sum + sonotha_sum - hansikin - shikyuhin)

    shinsheino = $('#keihihead_申請番号').val()
    $('.shinsheino').val(shinsheino)


  $(document).on 'click', '.delete-all', (event) ->
    $('.check-remove').each () ->
      $(this).val('1')
      $(this).closest('tr').hide()

      $('#keihihead_交通費合計').val(0)
      $('#keihihead_日当合計').val(0)
      $('#keihihead_宿泊費合計').val(0)
      $('#keihihead_その他合計').val(0)
      $('#keihihead_旅費合計').val(0)
      $('#keihihead_合計').val(0)
      $('#keihihead_過不足').val(0)
      $('#keihihead_仮払金').val(0)
    event.preventDefault()

  $(document).on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
#    $(this).closest('fieldset').remove()
    event.preventDefault()

  $(document).on 'click', '.remove_row', (event) ->
    $(this).closest('tr').find('.check-remove').val('1')
    $(this).closest('tr').hide()
    event.preventDefault()

  $(document).on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $(document).on 'click', '.add_row', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#keihi-table').find('tr').last().after($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $(document).on 'focus', '.datepicker', (event) ->
    $(this).datetimepicker({
      format: 'YYYY/MM/DD',
      widgetPositioning: {
        horizontal: 'left',
        vertical: 'bottom'
      }
      showTodayButton: true,
      showClear: true,
#    //,daysOfWeekDisabled:[0,6]
    calendarWeeks: true,
    keyBinds: false,
    focusOnShow: false

    })
    event.preventDefault()

  $(document).on 'click', '#keihi-table tr', (event) ->
    $('#keihi-table tr.selected').removeClass('selected')
    $(this).addClass('selected')
    event.preventDefault

  $(document).on 'click', '.atesaki-search', (event) ->
    $('#kaisha-search-modal').modal('show')
    event.preventDefault()

  $(document).on 'click', '.job-search', (event) ->
    $('#job_search_modal').modal('show')
    event.preventDefault()
  $('#event_sanshou_table tbody').on 'click', 'tr', (event) ->
    d = oEvent_sanshou_modal.row(this).data()
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oEvent_sanshou_modal.$('tr.selected').removeClass('selected')
      oEvent_sanshou_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $('#kaisha-table-modal tbody').on 'click', 'tr', (event) ->
    d = oKaisha_search_modal.row(this).data()
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKaisha_search_modal.$('tr.selected').removeClass('selected')
      oKaisha_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $('#job_table tbody').on 'click', 'tr', (event) ->
    d = oJob_search_modal.row(this).data()
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oJob_search_modal.$('tr.selected').removeClass('selected')
      oJob_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $('#myjob_table tbody').on 'click', 'tr', (event) ->
    d = oMyjobTable.row(this).data()
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oMyjobTable.$('tr.selected').removeClass('selected')
      oMyjobTable.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $('#mykaisha_table tbody').on 'click', 'tr', (event) ->
    d = oMykaishaTable.row(this).data()
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oMykaishaTable.$('tr.selected').removeClass('selected')
      oMykaishaTable.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $(document).on 'click', '.kikan-search', (event) ->
    $('#kikan-search-modal').modal('show')
    event.preventDefault()

  $('#kikan-table-modal tbody').on 'click', 'tr', (event) ->
    d = oKikan_search_modal.row(this).data()
    $('#keihi-table tr.selected').find('.kikan-name').val(d[1])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKikan_search_modal.$('tr.selected').removeClass('selected')
      oKikan_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  eki = ''
  $('#eki-table-modal tbody').on 'click', 'tr', (event) ->
    d = oEki_search_modal.row(this).data()
    if eki is '1'
      $('#keihi-table tr.selected').find('.hastu-name').val(d[1])
    else
      $('#keihi-table tr.selected').find('.chaku-name').val(d[1])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oEki_search_modal.$('tr.selected').removeClass('selected')
      oEki_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $(document).on 'click', '.hastu-search', (event) ->
    eki = '1'
    $('#eki-search-modal').modal('show')
    event.preventDefault()

  $(document).on 'click', '.chaku-search', (event) ->
    eki = '2'
    $('#eki-search-modal').modal('show')
    event.preventDefault()

#  init modal table
  oShonin_search_modal = $('#shonin-table-modal').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }})

  $('#shonin-table-modal tbody').on 'click', 'tr', (event) ->
    d = oShonin_search_modal.row(this).data()
    $('.shonin').val(d[1])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShonin_search_modal.$('tr.selected').removeClass('selected')
      oShonin_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $(document).on 'click', '.shonin-search', (event) ->
    $('#shonin-search-modal').modal('show')
    event.preventDefault()

  oShonin_table = $('.shonin-table').DataTable({
    "pagingType": "simple_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 13 ]},
      {
        "targets": [13],
        "width": '4%'
      }
    ]
  })

  $('.shonin-table').on( 'click', 'tr',  () ->
    d = oShonin_table.row(this).data()
    $('#jobmaster_ユーザ番号').val(d[0])
    $('#jobmaster_ユーザ名').val(d[1])

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShonin_table.$('tr.selected').removeClass('selected')
      oShonin_table.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )

  $(document).on 'focus', '#search', (event) ->
    $(this).datetimepicker({
      format: 'YYYY/MM/DD',
      widgetPositioning: {
        horizontal: 'left',
        vertical: 'bottom'
      }
      showTodayButton: true,
      showClear: true,
#    //,daysOfWeekDisabled:[0,6]
      calendarWeeks: true,
      keyBinds: false,
      focusOnShow: false

    })
    event.preventDefault()
  getDate = ->
    today = new Date();
    dd = today.getDate();
    mm = today.getMonth()+1;
    yyyy = today.getFullYear();
    if dd<10
      dd='0'+dd;
    if mm<10
      mm='0'+mm;
    date =yyyy+mm+dd


  oKeihiheadTable = $('.keihihead-table').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,"aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 19,20 ]},
      {
        "targets": [19,20],
        "width": '5%'
      }
      {"targets": [ 7..18 ],"visible": false }
      {"targets": [ 5 ],"visible": false }
    ],
    "order": [],
    "oSearch": {"sSearch": queryParameters().search},
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
    "buttons": [{
                "extend":    'copyHtml5',
                "text":      '<i class="fa fa-files-o"></i>',
                "titleAttr": 'Copy',
                "exportOptions": {
                  "columns": [0..18]
                }
            },
            {
                "extend":    'excelHtml5',
                "text":      '<i class="fa fa-file-excel-o"></i>',
                "titleAttr": 'Excel',
                "exportOptions": {
                  "columns": [0..18]
                },
                "filename": '経費出費明細_'+getDate()
            },
            {
                "extend":    'csvHtml5',
                "text":      '<i class="fa fa-file-text-o"></i>',
                "titleAttr": 'CSV',
                "exportOptions": {
                  "columns": [0..18]
                },
                "filename": '経費出費明細_'+getDate()
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oKeihiheadTable.$('tr').addClass('selected')
                oKeihiheadTable.$('tr').addClass('success')
                selects = oKeihiheadTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#destroy_keihihead").attr("disabled", true);
                else
                  $("#destroy_keihihead").attr("disabled", false);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oKeihiheadTable.$('tr').removeClass('selected')
                oKeihiheadTable.$('tr').removeClass('success')
                selects = oKeihiheadTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#destroy_keihihead").attr("disabled", true);
                else
                  $("#destroy_keihihead").attr("disabled", false);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })



  $('#keihihead_清算予定日_search').datetimepicker({
    format: 'YYYY/MM/DD',
    widgetPositioning: {
            horizontal: 'left'
        },
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    keyBinds: false,
    focusOnShow: false
  })

  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD',
    widgetPositioning: {
            horizontal: 'left'
        },
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    keyBinds: false,
    focusOnShow: false
  })

  $('#keihihead_日付').click () ->
    $('.keihihead_日付 .datetime').data("DateTimePicker").toggle();
  $('#keihihead_清算予定日').click () ->
    $('.keihihead_清算予定日 .datetime').data("DateTimePicker").toggle();

  $('#search_date_icon_group').click (e) ->
    $('#keihihead_清算予定日_search').data("DateTimePicker").toggle();

  $('#keihihead_清算予定日_search').click (e) ->
    $('#keihihead_清算予定日_search').data("DateTimePicker").toggle();

  $('#search').click () ->
    $('.datetime').data("DateTimePicker").toggle();

  # $('.datepicker_search').datetimepicker({
  #   format: 'YYYY-MM-DD',
  #   widgetPositioning: {
  #     horizontal: 'left',
  #     vertical: 'bottom'
  #   }
  #   showTodayButton: true,
  #   showClear: true,
  #   calendarWeeks: true,
  #   keyBinds: false,
  #   focusOnShow: false

  # })

  $('#keihihead_清算予定日_search ').on('dp.change', () ->
    date = $(this).val()
    shain = $('#keihihead_対象者').val()
    shonin = $('#keihihead_承認済区分').val()
    location.href = '/keihiheads?locale=ja&date=' +date+'&shain='+shain+'&shonin='+shonin
  )

  $('#keihihead_対象者').on('change', () ->
    shain = $(this).val()
    date =  $('.datepicker_search').val()
    shonin = $('#keihihead_承認済区分').val()
    location.href = '/keihiheads?locale=ja&date=' +date+'&shain='+shain+'&shonin='+shonin
  )
  $('#keihihead_承認済区分').on('change', () ->
    shonin = $(this).val()
    date =  $('.datepicker_search').val()
    shain = $('#keihihead_対象者').val()
    location.href = '/keihiheads?locale=ja&date=' +date+'&shain='+shain+'&shonin='+shonin
  )

  $('#summary').click( () ->
    swal('now')
  )

  $('#export_keihihead').click( () ->
    location.href='/keihiheads/export_csv.csv?locale=ja';
  )

  $('.keihihead-table').on( 'click', 'td',  () ->
    numColumn = oKeihiheadTable.cell(this).index().column
    if numColumn != 19 && numColumn != 20
      rowIdx = oKeihiheadTable.cell( this ).index().row
      d = oKeihiheadTable.row(rowIdx).data()
      thisRow = oKeihiheadTable.row(rowIdx).nodes().to$()
      if d != undefined
        if $(thisRow).hasClass('selected')
          $(thisRow).removeClass('selected')
          $(thisRow).removeClass('success')
        else
          $(thisRow).addClass('selected')
          $(thisRow).addClass('success')

      selects = oKeihiheadTable.rows('tr.selected').data()
      if selects.length == 0
        $("#destroy_keihihead").attr("disabled", true);
        $(".buttons-select-none").addClass('disabled')
      else
        $("#destroy_keihihead").attr("disabled", false);
        $(".buttons-select-none").removeClass('disabled')

  )

  $('#destroy_keihihead').click () ->
    keihiheads = oKeihiheadTable.rows('tr.selected').data()
    keihiheadIds = new Array();
    if keihiheads.length == 0
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
        len = keihiheads.length
        k = 0
        shain = $('#shain_login').text()
        check_permit = true
        for i in [0...len]
          if keihiheads[i][4] != "1" && keihiheads[i][6] == shain
            keihiheadIds[k] = keihiheads[i][0]
            k = k+1
          else
            check_permit = false
        if check_permit == false
          swal("他の経費データまたは承認済みのデータでは削除できません。")
        if k > 0
          $.ajax({
            url: '/keihiheads/ajax',
            data:{
              id: 'keihihead_削除する',
              keihiheads: keihiheadIds
            },

            type: "POST",

            success: (data) ->
              swal("削除されました!", "", "success");
              if data.destroy_success != null
                console.log("getAjax destroy_success:"+ data.destroy_success)
                keihiheads = oKeihiheadTable.rows('tr.selected').data()

                if keihiheads.length > 0
                  for i in [0...len]
                    if keihiheads[i][4] == "1" || keihiheads[i][6] != shain
                      rowId = $('.keihihead-table').dataTable().fnFindCellRowIndexes(keihiheads[i][0], 0);
                      thisRow = oKeihiheadTable.row(rowId).nodes().to$()
                      if $(thisRow).hasClass('selected')
                        $(thisRow).removeClass('selected')
                        $(thisRow).removeClass('success')

                $(".keihihead-table").dataTable().fnDeleteRow($('.keihihead-table').find('tr.selected').remove())
                $(".keihihead-table").dataTable().fnDraw()

              else
                console.log("getAjax destroy_success:"+ data.destroy_success)


            failure: () ->
              console.log("keihihead_削除する keydown Unsuccessful")

          })
        else
          keihiheads = oKeihiheadTable.rows('tr.selected').data()
          if keihiheads.length > 0
            for i in [0...len]
              if keihiheads[i][4] == "1" || keihiheads[i][6] != shain
                rowId = $('.keihihead-table').dataTable().fnFindCellRowIndexes(keihiheads[i][0], 0);
                thisRow = oKeihiheadTable.row(rowId).nodes().to$()
                if $(thisRow).hasClass('selected')
                  $(thisRow).removeClass('selected')
                  $(thisRow).removeClass('success')
        $("#destroy_keihihead").attr("disabled", true);
      ,(dismiss) ->
        if dismiss == 'cancel'
          selects = oKeihiheadTable.rows('tr.selected').data()
          if selects.length == 0
            $("#destroy_keihihead").attr("disabled", true);
          else
            $("#destroy_keihihead").attr("disabled", false);
      );
      # response = confirm($('#message_confirm_delete').text())
      # if response
      #   len = keihiheads.length
      #   k = 0
      #   shain = $('#shain_login').text()
      #   check_permit = true
      #   for i in [0...len]
      #     if keihiheads[i][4] != "1" && keihiheads[i][6] == shain
      #       keihiheadIds[k] = keihiheads[i][0]
      #       k = k+1
      #     else
      #       check_permit = false
      #   if check_permit == false
      #     swal("他の経費データまたは承認済みのデータでは削除できません。")
      #   if k > 0
      #     $.ajax({
      #       url: '/keihiheads/ajax',
      #       data:{
      #         id: 'keihihead_削除する',
      #         keihiheads: keihiheadIds
      #       },

      #       type: "POST",

      #       success: (data) ->
      #         if data.destroy_success != null
      #           console.log("getAjax destroy_success:"+ data.destroy_success)
      #           keihiheads = oKeihiheadTable.rows('tr.selected').data()

      #           if keihiheads.length > 0
      #             for i in [0...len]
      #               if keihiheads[i][4] == "1" || keihiheads[i][6] != shain
      #                 rowId = $('.keihihead-table').dataTable().fnFindCellRowIndexes(keihiheads[i][0], 0);
      #                 thisRow = oKeihiheadTable.row(rowId).nodes().to$()
      #                 if $(thisRow).hasClass('selected')
      #                   $(thisRow).removeClass('selected')
      #                   $(thisRow).removeClass('success')

      #           $(".keihihead-table").dataTable().fnDeleteRow($('.keihihead-table').find('tr.selected').remove())
      #           $(".keihihead-table").dataTable().fnDraw()

      #         else
      #           console.log("getAjax destroy_success:"+ data.destroy_success)


      #       failure: () ->
      #         console.log("keihihead_削除する keydown Unsuccessful")

      #     })
      #   else
      #     keihiheads = oKeihiheadTable.rows('tr.selected').data()
      #     if keihiheads.length > 0
      #       for i in [0...len]
      #         if keihiheads[i][4] == "1" || keihiheads[i][6] != shain
      #           rowId = $('.keihihead-table').dataTable().fnFindCellRowIndexes(keihiheads[i][0], 0);
      #           thisRow = oKeihiheadTable.row(rowId).nodes().to$()
      #           if $(thisRow).hasClass('selected')
      #             $(thisRow).removeClass('selected')
      #             $(thisRow).removeClass('success')
      #   $("#destroy_keihihead").attr("disabled", true);
      # else
      #   selects = oKeihiheadTable.rows('tr.selected').data()
      #   if selects.length == 0
      #     $("#destroy_keihihead").attr("disabled", true);
      #   else
      #     $("#destroy_keihihead").attr("disabled", false);

  $('#pdf_keihihead').click () ->
    shain = $('#keihihead_対象者').val()
    date =  $('.datepicker_search').val()
    shonin = $('#keihihead_承認済区分').val()
    window.open('/keihiheads/pdf_show.pdf?locale=ja&date=' +date+'&shain='+shain+'&shonin='+shonin)

  $('#pdf_show_keihihead').click () ->
    keihiheadId = $('#keihihead_id').val()
    window.open('/keihiheads/pdf_show.pdf?locale=ja&keihiheadId=' +keihiheadId)