jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oTable = $('.ykkkretable').DataTable({
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
      { "bSortable": false, "aTargets": [ 5,6 ]},
      {
        "targets": [5,6],
        "width": '5%'
      }
      {
        "targets": 0,
        "visible": false
      }
    ],
    "columns":[
      { "width" : "20%" },
      { "width" : "20%" },
      { "width" : "20%" },
      { "width" : "20%" },
      { "width" : "20%" }
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
                  $("#edit_ykkkre").attr("disabled", true);
                  $("#destroy_ykkkre").attr("disabled", true);
                else
                  $("#destroy_ykkkre").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_ykkkre").attr("disabled", false);
                  else
                    $("#edit_ykkkre").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')
            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_ykkkre").attr("disabled", true);
                  $("#destroy_ykkkre").attr("disabled", true);
                else
                  $("#destroy_ykkkre").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_ykkkre").attr("disabled", false);
                  else
                    $("#edit_ykkkre").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_ykkkre").attr("disabled", true);
  $("#destroy_ykkkre").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_ykkkre', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )

  $('.ykkkretable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_ykkkre").attr("disabled", true);
        # $("#destroy_ykkkre").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        #$("#edit_ykkkre").attr("disabled", true);
        # $("#edit_ykkkre").attr("disabled", false);
        # $("#destroy_ykkkre").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_ykkkre").attr("disabled", true);
      $("#destroy_ykkkre").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_ykkkre").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_ykkkre").attr("disabled", false);
      else
        $("#edit_ykkkre").attr("disabled", true);

  )

  $('#destroy_ykkkre').click () ->
    ykkkres = oTable.rows('tr.selected').data()
    ykkkreIds = new Array();
    if ykkkres.length == 0
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
        len = ykkkres.length
        for i in [0...len]
          ykkkreIds[i] = ykkkres[i][0]

        $.ajax({
          url: '/yuukyuu_kyuuka_rirekis/ajax',
          data:{
            focus_field: 'ykkkre_削除する',
            ykkkres: ykkkreIds
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
            console.log("ykkkre_削除する keydown Unsuccessful")

        })
        $("#edit_ykkkre").attr("disabled", true);
        $("#destroy_ykkkre").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_ykkkre").attr("disabled", true);
            $("#destroy_ykkkre").attr("disabled", true);
          else
            $("#destroy_ykkkre").attr("disabled", false);
            if selects.length == 1
              $("#edit_ykkkre").attr("disabled", false);
            else
              $("#edit_ykkkre").attr("disabled", true);
      );
  $('#edit_ykkkre').click ->
    new_address = oTable.row('tr.selected').data()[5].split("\"")[1]
    if new_address == undefined
      swal("行を選択してください。")
    else
      window.location = new_address
  $('.datetime').datetimepicker({
    format: 'YYYY/MM',
    viewMode: 'months',
    keyBinds: false,
    focusOnShow: false
    }).on('dp.show', ()->
        $('.datetime').data("DateTimePicker").viewMode("months")
    );
  $('#yuukyuu_kyuuka_rireki_年月').click () ->
    $('.datetime').data("DateTimePicker").viewMode("months").toggle()