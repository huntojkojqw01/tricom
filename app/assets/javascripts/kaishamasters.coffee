jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oKaishaTable = $('.kaishatable').DataTable({
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
                "extend":    'import',
                "text":      '<i class="glyphicon glyphicon-import"></i>',
                "titleAttr": 'Import'
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oKaishaTable.$('tr').addClass('selected')
                oKaishaTable.$('tr').addClass('success')
                selects = oKaishaTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kaisha").addClass("disabled");
                  $("#destroy_kaisha").addClass("disabled");
                else
                  $("#destroy_kaisha").removeClass("disabled");
                  if selects.length == 1
                    $("#edit_kaisha").removeClass("disabled");
                  else
                    $("#edit_kaisha").addClass("disabled");
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oKaishaTable.$('tr').removeClass('selected')
                oKaishaTable.$('tr').removeClass('success')
                selects = oKaishaTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kaisha").addClass("disabled");
                  $("#destroy_kaisha").addClass("disabled");
                else
                  $("#destroy_kaisha").removeClass("disabled");
                  if selects.length == 1
                    $("#edit_kaisha").removeClass("disabled");
                  else
                    $("#edit_kaisha").addClass("disabled");
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })
  $("#edit_kaisha").addClass("disabled");
  $("#destroy_kaisha").addClass("disabled");


  $(document).bind('ajaxError', 'form#new_kaishamaster', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )

  $.fn.render_form_errors = (errors) ->
    $form = this;
    this.clear_previous_errors();
    model = this.data('model');


    $.each(errors, (field, messages) ->
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    );


  $.fn.clear_previous_errors = () ->
    $('.form-group.has-error', this).each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );


  $('.kaishatable').on( 'click', 'tr',  () ->
    d = oKaishaTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_kaisha").addClass("disabled");
        # $("#destroy_kaisha").addClass("disabled");
      else
        # oKaishaTable.$('tr.selected').removeClass('selected')
        # oKaishaTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        #$("#edit_kaisha").addClass("disabled");
        # $("#edit_kaisha").removeClass("disabled");
        # $("#destroy_kaisha").removeClass("disabled");
    selects = oKaishaTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_kaisha").addClass("disabled");
      $("#destroy_kaisha").addClass("disabled");
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_kaisha").removeClass("disabled");
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_kaisha").removeClass("disabled");
      else
        $("#edit_kaisha").addClass("disabled");

  )

  $('#destroy_kaisha').click () ->
    kaishas = oKaishaTable.rows('tr.selected').data()
    kaishaIds = new Array();
    if kaishas.length == 0
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
        len = kaishas.length
        for i in [0...len]
          kaishaIds[i] = kaishas[i][0]

        $.ajax({
          url: '/kaishamasters/ajax',
          data:{
            focus_field: 'kaisha_削除する',
            kaishas: kaishaIds
          },

          type: "POST",

          success: (data) ->
            swal("削除されました!", "", "success");
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              oKaishaTable.rows('tr.selected').remove().draw()
            else
              console.log("getAjax destroy_success:"+ data.destroy_success)


          failure: () ->
            console.log("kaisha_削除する keydown Unsuccessful")

        })
        $("#edit_kaisha").addClass("disabled");
        $("#destroy_kaisha").addClass("disabled");

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oKaishaTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_kaisha").addClass("disabled");
            $("#destroy_kaisha").addClass("disabled");
          else
            $("#destroy_kaisha").removeClass("disabled");
            if selects.length == 1
              $("#edit_kaisha").removeClass("disabled");
            else
              $("#edit_kaisha").addClass("disabled");
      );
  $('#new_kaisha').click ()->
      $('#kaisha-new-modal').modal('show')
      #$('#jpt_holiday_mst_id').val('');
      $('#kaishamaster_会社コード').val('')
      $('#kaishamaster_会社名').val('')
      $('#kaishamaster_備考').val('')
      $('.form-group.has-error').each ()->
        $('.help-block', $(this)).html('')
        $(this).removeClass('has-error')
  $('#edit_kaisha').click () ->
    kaisha = oKaishaTable.row('tr.selected').data()
    $('.form-group.has-error').each () ->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
    if (kaisha == undefined)
      swal("行を選択してください。")
    else
      $('#kaisha-edit-modal').modal('show')
      $('#kaishamaster_会社コード').val(kaisha[0])
      $('#kaishamaster_会社名').val(kaisha[1])
      $('#kaishamaster_備考').val(kaisha[2])