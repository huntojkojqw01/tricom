jQuery ->
  oTable = $('.kouteitable').DataTable({
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
      { "bSortable": false, "aTargets": [ 4,5]},
      {
        "targets": [4,5],
        "width": '5%'
      },
      {
        "targets": 0,
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
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_koutei").attr("disabled", true);
                  $("#destroy_koutei").attr("disabled", true);
                else
                  $("#destroy_koutei").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_koutei").attr("disabled", false);
                  else
                    $("#edit_koutei").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_koutei").attr("disabled", true);
                  $("#destroy_koutei").attr("disabled", true);
                else
                  $("#destroy_koutei").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_koutei").attr("disabled", false);
                  else
                    $("#edit_koutei").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_koutei").attr("disabled", true);
  $("#destroy_koutei").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_kouteimaster', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )

  $('.kouteitable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_koutei").attr("disabled", true);
        # $("#destroy_koutei").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        #$("#edit_koutei").attr("disabled", true);
        # $("#edit_koutei").attr("disabled", false);
        # $("#destroy_koutei").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_koutei").attr("disabled", true);
      $("#destroy_koutei").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_koutei").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_koutei").attr("disabled", false);
      else
        $("#edit_koutei").attr("disabled", true);

  )

  $('#destroy_koutei').click () ->
    kouteis = oTable.rows('tr.selected').data()
    kouteiIds = new Array();
    if kouteis.length == 0
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
        len = kouteis.length
        for i in [0...len]
          kouteiIds[i] = kouteis[i][4].split('/')[2]

        $.ajax({
          url: '/kouteimasters/multi_delete',
          data:{
            focus_field: 'koutei_削除する',
            kouteis: kouteiIds
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
            console.log("koutei_削除する keydown Unsuccessful")

        })
        $("#edit_koutei").attr("disabled", true);
        $("#destroy_koutei").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_koutei").attr("disabled", true);
            $("#destroy_koutei").attr("disabled", true);
          else
            $("#destroy_koutei").attr("disabled", false);
            if selects.length == 1
              $("#edit_koutei").attr("disabled", false);
            else
              $("#edit_koutei").attr("disabled", true);
      );
  $('#new_koutei').click ()->
      $('#koutei-new-modal').modal('show')
      $('#kouteimaster_所属コード').val('')
      $('#kouteimaster_工程コード').val('')
      $('#kouteimaster_工程名').val('')
      $('.form-group.has-error').each ()->
        $('.help-block', $(this)).html('')
        $(this).removeClass('has-error')
  $('#edit_koutei').click () ->
    koutei = oTable.row('tr.selected').data()
    $('.form-group.has-error').each () ->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
    if (koutei == undefined)
      swal("行を選択してください。")
    else
      $('#koutei-edit-modal').modal('show')
      $('#kouteimaster_所属コード').val(koutei[0])
      $('#kouteimaster_工程コード').val(koutei[2])
      $('#kouteimaster_工程名').val(koutei[3])