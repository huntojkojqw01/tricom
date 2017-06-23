jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oTable = $('.bashotable').DataTable({
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
      { "bSortable": false, "aTargets": [ 6,7 ]},
      {
        "targets": [6,7],
        "width": '5%'
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
                  $("#edit_basho").attr("disabled", true);
                  $("#destroy_basho").attr("disabled", true);
                else
                  $("#destroy_basho").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_basho").attr("disabled", false);
                  else
                    $("#edit_basho").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_basho").attr("disabled", true);
                  $("#destroy_basho").attr("disabled", true);
                else
                  $("#destroy_basho").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_basho").attr("disabled", false);
                  else
                    $("#edit_basho").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_basho").attr("disabled", true);
  $("#destroy_basho").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_bashomaster', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )



  $('.bashotable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
      else
        $(this).addClass('selected')
        $(this).addClass('success')
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_basho").attr("disabled", true);
      $("#destroy_basho").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_basho").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_basho").attr("disabled", false);
      else
        $("#edit_basho").attr("disabled", true);

  )

  $('#destroy_basho').click () ->
    bashos = oTable.rows('tr.selected').data()
    bashoIds = new Array();
    if bashos.length == 0
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
        len = bashos.length
        for i in [0...len]
          bashoIds[i] = bashos[i][0]

        $.ajax({
          url: '/bashomasters/ajax',
          data:{
            focus_field: 'basho_削除する',
            bashos: bashoIds
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
            console.log("basho_削除する keydown Unsuccessful")

        })
        $("#edit_basho").attr("disabled", true);
        $("#destroy_basho").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_basho").attr("disabled", true);
            $("#destroy_basho").attr("disabled", true);
          else
            $("#destroy_basho").attr("disabled", false);
            if selects.length == 1
              $("#edit_basho").attr("disabled", false);
            else
              $("#edit_basho").attr("disabled", true);
      );
  $('#edit_basho').click ->
    new_address = oTable.row('tr.selected').data()[6].split("\"")[1]
    if new_address == undefined
      swal("行を選択してください。")
    else
      window.location = new_address
