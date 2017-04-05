jQuery ->
  oTable = $('#jobmaster').DataTable({
    "dom": 'lBfrtip',
    "scrollX": true,
#    'scrollY': "300px",
    "pagingType": "full_numbers",
    "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 10,11 ]},
      {
        "targets": [10,11],
        "width": '5%'
      }
    ],
    "columnDefs": [{
      "targets"  : 'no-sort',
      "orderable": false
    }],
    'scrollCollapse': true,
#    'fixedColumns': {
#      'leftColumns': 0,
#      'rightColumns': 2,
#      'heightMatch': 'none'
#    }
    "oSearch": {"sSearch": queryParameters().search},

    "buttons": [{
                "extend":    'copyHtml5',
                "text":      '<i class="fa fa-files-o"></i>',
                "titleAttr": 'Copy'
            },
            {
                "extend":    'excelHtml5',
                "text":      '<i class="fa fa-file-excel-o"></i>',
                "titleAttr": 'Excel'
            },
            {
                "extend":    'csvHtml5',
                "text":      '<i class="fa fa-file-text-o"></i>',
                "titleAttr": 'CSV'
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_jobmaster").attr("disabled", true);
                  $("#destroy_jobmaster").attr("disabled", true);
                else
                  $("#destroy_jobmaster").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_jobmaster").attr("disabled", false);
                  else
                    $("#edit_jobmaster").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_jobmaster").attr("disabled", true);
                  $("#destroy_jobmaster").attr("disabled", true);
                else
                  $("#destroy_jobmaster").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_jobmaster").attr("disabled", false);
                  else
                    $("#edit_jobmaster").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]
  })
  $("#edit_jobmaster").attr("disabled", true);
  $("#destroy_jobmaster").attr("disabled", true);

  $('#jobmaster').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_jobmaster").attr("disabled", true);
        # $("#destroy_jobmaster").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_jobmaster").attr("disabled", false);
        # $("#destroy_jobmaster").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_jobmaster").attr("disabled", true);
      $("#destroy_jobmaster").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_jobmaster").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_jobmaster").attr("disabled", false);
      else
        $("#edit_jobmaster").attr("disabled", true);
  )
  oKaisha_modal = $('#kaisha-table-modal').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  oShain_modal = $('#user_table').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  oJob_modal = $('#job_table').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  oBunrui_modal = $('.bunrui-table').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  $('#kaisha-table-modal tbody').on( 'click', 'tr',  () ->
    d = oKaisha_modal.row(this).data()
  #$('#jobmaster_ユーザ番号').val(d[0])
  #$('#jobmaster_ユーザ名').val(d[1])

    #    remove error if has
 #  $('#jobmaster_ユーザ番号').closest('.form-group').find('span.help-block').remove()
 #  $('#jobmaster_ユーザ番号').closest('.form-group').removeClass('has-error')

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKaisha_modal.$('tr.selected').removeClass('selected')
      oKaisha_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
   )

  $('#user_table tbody').on( 'click', 'tr',  () ->
    d = oShain_modal.row(this).data()
#   $('#jobmaster_入力社員番号').val(d[0])
#   $('.hint-shain-refer').text(d[1])

#    remove error if has
#   $('#jobmaster_入力社員番号').closest('.form-group').find('span.help-block').remove()
#   $('#jobmaster_入力社員番号').closest('.form-group').removeClass('has-error')

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShain_modal.$('tr.selected').removeClass('selected')
      oShain_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )

  $('#job_table tbody').on( 'click', 'tr',  () ->
    d = oJob_modal.row(this).data()
 #  $('#jobmaster_関連Job番号').val(d[0])
 #  $('.hint-job-refer').text(d[1])

    #    remove error if has
 #  $('#jobmaster_関連Job番号').closest('.form-group').find('span.help-block').remove()
 #  $('#jobmaster_関連Job番号').closest('.form-group').removeClass('has-error')

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oJob_modal.$('tr.selected').removeClass('selected')
      oJob_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )

  $('.bunrui-table tbody').on( 'click', 'tr',  () ->
    d = oBunrui_modal.row(this).data()
 #  $('#jobmaster_分類コード').val(d[0])
 #  $('#jobmaster_分類名').val(d[1])

    #    remove error if has
 #  $('#jobmaster_分類コード').closest('.form-group').find('span.help-block').remove()
 #  $('#jobmaster_分類コード').closest('.form-group').removeClass('has-error')

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oBunrui_modal.$('tr.selected').removeClass('selected')
      oBunrui_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )


#  $('.start-date').click( () ->
#    $('#jobmaster_開始日').data("DateTimePicker").toggle()
#  )
#
#  $('.end-date').click( () ->
#    $('#jobmaster_終了日').data("DateTimePicker").toggle()
#  )

#  $('.calendar-span').click( () ->
#    $('#jobmaster_開始日').data("DateTimePicker").toggle()
##    element1 = $('.date').find($('#jobmaster_開始日'))
##    element2 = $('.date').find($('#jobmaster_終了日'))
##
##    if $(this).prev().is(element1)
##      $('#jobmaster_開始日').data("DateTimePicker").toggle()
##
##    if $(this).prev().is(element2)
##      $('#jobmaster_終了日').data("DateTimePicker").toggle()
#  )

  $('.date').datetimepicker({
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

#  $('#jobmaster_開始日').datetimepicker({
#    format: 'YYYY/MM/DD',
#    widgetPositioning: {
#      horizontal: 'left',
#      vertical: 'bottom'
#    }
#    showTodayButton: true,
#    showClear: true,
##    //,daysOfWeekDisabled:[0,6]
#    calendarWeeks: true,
#    keyBinds: false,
#    focusOnShow: false
#  })
#
#  $('#jobmaster_終了日').datetimepicker({
#    format: 'YYYY/MM/DD',
#    widgetPositioning: {
#      horizontal: 'left',
#      vertical: 'bottom'
#    }
#    showTodayButton: true,
#    showClear: true,
##    //,daysOfWeekDisabled:[0,6]
#    calendarWeeks: true,
#    keyBinds: false,
#    focusOnShow: false
#  })
#
#  $("#jobmaster_開始日").on("dp.change", (e) ->
#    $('#jobmaster_終了日').data("DateTimePicker").minDate(e.date)
#    e.preventDefault()
#  )
#
#  $("#jobmaster_終了日").on("dp.change", (e) ->
#    $('#jobmaster_開始日').data("DateTimePicker").maxDate(e.date);
#    e.preventDefault()
#  )

  $('.search-field').click( () ->
    element1 = $('.search-group').find('#jobmaster_ユーザ番号')
    element2 = $('.search-group').find('#jobmaster_入力社員番号')
    element3 = $('.search-group').find('#jobmaster_関連Job番号')

    if $(this).prev().is(element1)
      $('#kaisha-search-modal').modal('show')
      if $('#jobmaster_ユーザ番号').val() != ''
        oKaisha_modal.rows().every( ( rowIdx, tableLoop, rowLoop ) ->
          data = this.data();
          if data[0] == $('#jobmaster_ユーザ番号').val()
            oKaisha_modal.$('tr.selected').removeClass('selected');
            oKaisha_modal.$('tr.success').removeClass('success');
            this.nodes().to$().addClass('selected')
            this.nodes().to$().addClass('success')
        );
        oKaisha_modal.page.jumpToData($('#jobmaster_ユーザ番号').val(), 0);
    if $(this).prev().is(element2)
      $('#select_user_modal').modal('show')
      if $('#jobmaster_入力社員番号').val() != ''
        oShain_modal.rows().every( ( rowIdx, tableLoop, rowLoop ) ->
          data = this.data();
          if data[0] == $('#jobmaster_入力社員番号').val()
            oShain_modal.$('tr.selected').removeClass('selected');
            oShain_modal.$('tr.success').removeClass('success');
            this.nodes().to$().addClass('selected')
            this.nodes().to$().addClass('success')
        );
        oShain_modal.page.jumpToData($('#jobmaster_入力社員番号').val(), 0);

    if $(this).prev().is(element3)
      $('#job_search_modal').modal('show')
      if $('#jobmaster_関連Job番号').val() != ''
        oJob_modal.rows().every( ( rowIdx, tableLoop, rowLoop ) ->
          data = this.data();
          if data[0] == $('#jobmaster_関連Job番号').val()
            oJob_modal.$('tr.selected').removeClass('selected');
            oJob_modal.$('tr.success').removeClass('success');
            this.nodes().to$().addClass('selected')
            this.nodes().to$().addClass('success')
        );
        oJob_modal.page.jumpToData($('#jobmaster_関連Job番号').val(), 0);
  )

#  $('.refer-kaisha').click( () ->
#    $('#kaisha-search-modal').modal('show')
#  )
#
#  $('.refer-shain').click( () ->
#    $('#select_user_modal').modal('show')
#  )
#
#  $('.refer-job').click( () ->
#    $('#job_search_modal').modal('show')
#  )

#  $('.refer-bunrui').click( () ->
#    $('#bunrui_search_modal').modal('show')
#  )

  $('#jobmaster_ユーザ番号').keydown( (e) ->
    if (e.keyCode == 9 && !e.shiftKey)
      kaisha_code = $('#jobmaster_ユーザ番号').val()
      jQuery.ajax({
        url: '/jobmasters/ajax',
        data: {focus_field: 'jobmaster_ユーザ番号', kaisha_code: kaisha_code},
        type: "POST",
      success: (data) ->
#        $('#kaisha-name').text(data.kaisha_name)
        $('#jobmaster_ユーザ名').val(data.kaisha_name)
        console.log("getAjax jobmaster_ユーザ番号:"+ data.kaisha_name)
      ,
      failure: () ->
        console.log("jobmaster_ユーザ番号 keydown Unsuccessful")
      })
  )

#  $('#jobmaster_分類コード').on('change', () ->
#    switch $(this).val()
#      when '1'
#        $('#jobmaster_分類名').val('営業活動')
#      when '2'
#        $('#jobmaster_分類名').val('開発マスタ')
#      when '3'
#        $('#jobmaster_分類名').val('保守')
#      when '4'
#        $('#jobmaster_分類名').val('社内業務')
#  )

  $('#destroy_jobmaster').click () ->
    jobs = oTable.rows('tr.selected').data()
    jobIds = new Array();
    if jobs.length == 0
      swal($('#message_confirm_select').text())
    else
      swal({
        title: $('#message_confirm_delete').text(),
        text: "削除でよろしいですが？",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "OK",
        cancelButtonText: "キャンセル",
        closeOnConfirm: false,
        closeOnCancel: false
      }).then(() ->
        len = jobs.length
        for i in [0...len]
          jobIds[i] = jobs[i][0]

        $.ajax({
          url: '/jobmasters/ajax',
          data:{
            focus_field: 'jobmaster_削除する',
            jobs: jobIds
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
            console.log("job_削除する keydown Unsuccessful")

        })
        $("#edit_jobmaster").attr("disabled", true);
        $("#destroy_jobmaster").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_jobmaster").attr("disabled", true);
            $("#destroy_jobmaster").attr("disabled", true);
          else
            $("#destroy_jobmaster").attr("disabled", false);
            if selects.length == 1
              $("#edit_jobmaster").attr("disabled", false);
            else
              $("#edit_jobmaster").attr("disabled", true);

      );

  $('#edit_jobmaster').click () ->
    job_id = oTable.row('tr.selected').data()
    window.location = '/jobmasters/' + job_id[0] + '/edit?locale=ja'

  $('#clear_kaisha').click ->
    oKaisha_modal.$('tr.selected').removeClass 'selected'
    oKaisha_modal.$('tr.success').removeClass 'success'

  $('#clear_job').click ->
    oJob_modal.$('tr.selected').removeClass 'selected'
    oJob_modal.$('tr.success').removeClass 'success'

  $('#clear_shain').click ->
    oShain_modal.$('tr.selected').removeClass 'selected'
    oShain_modal.$('tr.success').removeClass 'success'

  $('#job_sentaku_ok').click ->
    d = oJob_modal.row('tr.selected').data()
    if d != undefined
      $('#jobmaster_関連Job番号').val d[0]
      $('.hint-job-refer').val d[1]
      $('#jobmaster_関連Job番号').closest('.form-group').find('span.help-block').remove()
      $('#jobmaster_関連Job番号').closest('.form-group').removeClass 'has-error'

  $('#user_refer_sentaku_ok').click ->
    d = oShain_modal.row('tr.selected').data()
    if d != undefined
      $('#jobmaster_入力社員番号').val d[0]
      $('.hint-shain-refer').val d[1]
      $('#jobmaster_入力社員番号').closest('.form-group').find('span.help-block').remove()
      $('#jobmaster_入力社員番号').closest('.form-group').removeClass 'has-error'

  $('#kaisha_sentaku_ok').click ->
    d = oKaisha_modal.row('tr.selected').data()
    if d != undefined
      $('#jobmaster_ユーザ番号').val d[0]
      $('#jobmaster_ユーザ名').val d[1]
      $('#jobmaster_ユーザ番号').closest('.form-group').find('span.help-block').remove()
      $('#jobmaster_ユーザ番号').closest('.form-group').removeClass 'has-error'

