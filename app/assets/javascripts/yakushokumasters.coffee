jQuery ->
  oTable = $('.yakushokutable').DataTable({
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
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_yakushoku").attr("disabled", true);
                  $("#destroy_yakushoku").attr("disabled", true);
                else
                  $("#destroy_yakushoku").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_yakushoku").attr("disabled", false);
                  else
                    $("#edit_yakushoku").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_yakushoku").attr("disabled", true);
                  $("#destroy_yakushoku").attr("disabled", true);
                else
                  $("#destroy_yakushoku").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_yakushoku").attr("disabled", false);
                  else
                    $("#edit_yakushoku").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })
  $("#edit_yakushoku").attr("disabled", true);
  $("#destroy_yakushoku").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_yakushokumaster', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )

  $('.yakushokutable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_yakushoku").attr("disabled", true);
        # $("#destroy_yakushoku").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        #$("#edit_yakushoku").attr("disabled", true);
        # $("#edit_yakushoku").attr("disabled", false);
        # $("#destroy_yakushoku").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_yakushoku").attr("disabled", true);
      $("#destroy_yakushoku").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_yakushoku").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_yakushoku").attr("disabled", false);
      else
        $("#edit_yakushoku").attr("disabled", true);

  )

  $('#destroy_yakushoku').click () ->
    yakushokus = oTable.rows('tr.selected').data()
    yakushokuIds = new Array();
    if yakushokus.length == 0
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
        len = yakushokus.length
        for i in [0...len]
          yakushokuIds[i] = yakushokus[i][0]

        $.ajax({
          url: '/yakushokumasters/ajax',
          data:{
            focus_field: 'yakushoku_削除する',
            yakushokus: yakushokuIds
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
            console.log("yakushoku_削除する keydown Unsuccessful")

        })
        $("#edit_yakushoku").attr("disabled", true);
        $("#destroy_yakushoku").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_yakushoku").attr("disabled", true);
            $("#destroy_yakushoku").attr("disabled", true);
          else
            $("#destroy_yakushoku").attr("disabled", false);
            if selects.length == 1
              $("#edit_yakushoku").attr("disabled", false);
            else
              $("#edit_yakushoku").attr("disabled", true);
      );
  $('#new_yakushoku').click ()->
      $('#yakushoku-new-modal').modal('show')
      #$('#jpt_holiday_mst_id').val('');
      $('#yakushokumaster_役職コード').val('')
      $('#yakushokumaster_役職名').val('')
      $('.form-group.has-error').each ()->
        $('.help-block', $(this)).html('')
        $(this).removeClass('has-error')
  $('#edit_yakushoku').click () ->
    yakushoku = oTable.row('tr.selected').data()
    $('.form-group.has-error').each () ->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
    if (yakushoku == undefined)
      swal("行を選択してください。")
    else
      $('#yakushoku-edit-modal').modal('show')
      $('#yakushokumaster_役職コード').val(yakushoku[0])
      $('#yakushokumaster_役職名').val(yakushoku[1])