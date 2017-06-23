jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oTable = $('.holidaytable').DataTable({
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    "fnDrawCallback": (oSettings) ->
      $('.new-btn').appendTo($('.dt-buttons'));
      $('.edit-btn').appendTo($('.dt-buttons'));
      $('.delete-btn').appendTo($('.dt-buttons'));
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "aoColumnDefs": [
      # { "bSortable": false, "aTargets": [ 2,3 ]},
      # {
      #   "targets": [2,3],
      #   "width": '5%'
      # }
      {
        "targets": [ 0 ],
        "bSearchable": false,
        "visible": false
      }
    ],
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
                "extend":    'import',
                "text":      '<i class="glyphicon glyphicon-import"></i>',
                "titleAttr": 'Import'
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_holiday").attr("disabled", true);
                  $("#destroy_holiday").attr("disabled", true);
                else
                  $("#destroy_holiday").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_holiday").attr("disabled", false);
                  else
                    $("#edit_holiday").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_holiday").attr("disabled", true);
                  $("#destroy_holiday").attr("disabled", true);
                else
                  $("#destroy_holiday").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_holiday").attr("disabled", false);
                  else
                    $("#edit_holiday").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })
  $("#edit_holiday").attr("disabled", true);
  $("#destroy_holiday").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_jpt_holiday_mst', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )


  $('.holidaytable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_holiday").attr("disabled", true);
        # $("#destroy_holiday").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        #$("#edit_holiday").attr("disabled", true);
        # $("#edit_holiday").attr("disabled", false);
        # $("#destroy_holiday").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_holiday").attr("disabled", true);
      $("#destroy_holiday").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_holiday").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_holiday").attr("disabled", false);
      else
        $("#edit_holiday").attr("disabled", true);

  )

  $('#destroy_holiday').click () ->
    holidays = oTable.rows('tr.selected').data()
    holidayIds = new Array();
    if holidays.length == 0
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
        len = holidays.length
        for i in [0...len]
          holidayIds[i] = holidays[i][0]

        $.ajax({
          url: '/jpt_holiday_msts/ajax',
          data:{
            focus_field: 'holiday_削除する',
            holidays: holidayIds
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
            console.log("holiday_削除する keydown Unsuccessful")

        })
        $("#edit_holiday").attr("disabled", true);
        $("#destroy_holiday").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_holiday").attr("disabled", true);
            $("#destroy_holiday").attr("disabled", true);
          else
            $("#destroy_holiday").attr("disabled", false);
            if selects.length == 1
              $("#edit_holiday").attr("disabled", false);
            else
              $("#edit_holiday").attr("disabled", true);
      );
  $('#new_holiday').click ()->
    $('#holiday-new-modal').modal('show')
    #$('#jpt_holiday_mst_id').val('');
    $('#holiday-new-modal #jpt_holiday_mst_event_date').val('')
    $('#holiday-new-modal #jpt_holiday_mst_title').val('')
    $('#holiday-new-modal #jpt_holiday_mst_description').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
  $('#edit_holiday').click () ->
    holiday = oTable.row('tr.selected').data()
    $('.form-group.has-error').each () ->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
    if (holiday == undefined)
      swal("行を選択してください。")
    else
      $('#holiday-edit-modal').modal('show')
      $('#jpt_holiday_mst_id').val(holiday[0])
      $('#jpt_holiday_mst_event_date').val(holiday[1])
      $('#jpt_holiday_mst_title').val(holiday[2])
      $('#jpt_holiday_mst_description').val(holiday[3])
  $('#jpt_holiday_mst_event_date').datetimepicker({
    format: 'YYYY/MM/DD',
    widgetPositioning: {
      horizontal: 'left'
      },
    showTodayButton: true
  });
  $('#holiday-new-modal #jpt_holiday_mst_event_date').datetimepicker({
    format: 'YYYY/MM/DD',
    widgetPositioning: {
      horizontal: 'left'
    },
    showTodayButton: true
  });