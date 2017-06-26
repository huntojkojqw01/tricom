jQuery ->
  oTable = $('#yakushoku_table').DataTable({
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },

    "columnDefs": [{
      "targets"  : 'no-sort',
      "orderable": false
    }]
    ,"oSearch": {"sSearch": queryParameters().search}
  })
  $("#edit_yakushoku").addClass("disabled");
  $("#destroy_yakushoku").addClass("disabled");


  $(document).bind('ajaxError', 'form#new_yakushokumaster', (event, jqxhr, settings, exception) ->
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


  $('#yakushoku_table').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        $("#edit_yakushoku").addClass("disabled");
        $("#destroy_yakushoku").addClass("disabled");
      else
        oTable.$('tr.selected').removeClass('selected')
        oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        $("#edit_yakushoku").removeClass("disabled");
        $("#destroy_yakushoku").removeClass("disabled");
  )

  $('#destroy_yakushoku').click () ->
    yakushoku = oTable.row('tr.selected').data()

    if yakushoku == undefined
      swal($('#message_confirm_select').text())
    else
      $.ajax({
          url: '/yakushokumasters/ajax',
          data:{
            focus_field: 'yakushoku_before_destroy',
            yakushoku_id: yakushoku[0]
          },

          type: "POST",

          success: (data) ->
            if data.associations != ''
              swal({
                title: data.associations,
                text: "",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "OK",
                cancelButtonText: "キャンセル",
                closeOnConfirm: false,
                closeOnCancel: false
              }).then(() ->
                $.ajax({
                  url: '/yakushokumasters/ajax',
                  data:{
                    focus_field: 'yakushoku_削除する',
                    yakushoku_id: yakushoku[0]
                  },

                  type: "POST",

                  success: (data) ->
                    swal("削除されました!", "", "success");
                    if data.destroy_success != null
                      console.log("getAjax destroy_success:"+ data.destroy_success)
                      oTable.row('tr.selected').remove().draw()
                      #$("#yakushoku_table").dataTable().fnDeleteRow($('#yakushoku_table').find('tr.selected').remove())
                      #$("#yakushoku_table").dataTable().fnDraw()
                      $("#edit_yakushoku").addClass("disabled");
                      $("#destroy_yakushoku").addClass("disabled");
                  failure: () ->
                    console.log("yakushoku_削除する keydown Unsuccessful")
                    $("#edit_yakushoku").removeClass("disabled");
                    $("#destroy_yakushoku").removeClass("disabled");

                })
              ,(dismiss) ->
                if dismiss == 'cancel'
                  $("#edit_yakushoku").attr("disabled", false)
                  $("#destroy_yakushoku").attr("disabled", false)
              );
              # response = confirm(data.associations)
              # if response
              #   $.ajax({
              #     url: '/yakushokumasters/ajax',
              #     data:{
              #       focus_field: 'yakushoku_削除する',
              #       yakushoku_id: yakushoku[0]
              #     },

              #     type: "POST",

              #     success: (data) ->
              #       if data.destroy_success != null
              #         console.log("getAjax destroy_success:"+ data.destroy_success)
              #         $("#yakushoku_table").dataTable().fnDeleteRow($('#yakushoku_table').find('tr.selected').remove())
              #         $("#yakushoku_table").dataTable().fnDraw()
              #         $("#edit_yakushoku").addClass("disabled");
              #         $("#destroy_yakushoku").addClass("disabled");
              #     failure: () ->
              #       console.log("yakushoku_削除する keydown Unsuccessful")
              #       $("#edit_yakushoku").removeClass("disabled");
              #       $("#destroy_yakushoku").removeClass("disabled");

              #   })

              # else
              #   $("#edit_yakushoku").attr("disabled", false)
              #   $("#destroy_yakushoku").attr("disabled", false)

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
                $.ajax({
                  url: '/yakushokumasters/ajax',
                  data:{
                    focus_field: 'yakushoku_削除する',
                    yakushoku_id: yakushoku[0]
                  },

                  type: "POST",

                  success: (data) ->
                    swal("削除されました!", "", "success");
                    if data.destroy_success != null
                      console.log("getAjax destroy_success:"+ data.destroy_success)
                      oTable.row('tr.selected').remove().draw()
                      #$("#yakushoku_table").dataTable().fnDeleteRow($('#yakushoku_table').find('tr.selected').remove())
                      #$("#yakushoku_table").dataTable().fnDraw()
                      $("#edit_yakushoku").addClass("disabled");
                      $("#destroy_yakushoku").addClass("disabled");
                  failure: () ->
                    console.log("yakushoku_削除する keydown Unsuccessful")
                    $("#edit_yakushoku").removeClass("disabled");
                    $("#destroy_yakushoku").removeClass("disabled");

                })

              ,(dismiss) ->
                if dismiss == 'cancel'
                  $("#edit_yakushoku").attr("disabled", false)
                  $("#destroy_yakushoku").attr("disabled", false)
              );
              # response = confirm($('#message_confirm_delete').text())
              # if response
              #   $.ajax({
              #     url: '/yakushokumasters/ajax',
              #     data:{
              #       focus_field: 'yakushoku_削除する',
              #       yakushoku_id: yakushoku[0]
              #     },

              #     type: "POST",

              #     success: (data) ->
              #       if data.destroy_success != null
              #         console.log("getAjax destroy_success:"+ data.destroy_success)
              #         $("#yakushoku_table").dataTable().fnDeleteRow($('#yakushoku_table').find('tr.selected').remove())
              #         $("#yakushoku_table").dataTable().fnDraw()
              #         $("#edit_yakushoku").addClass("disabled");
              #         $("#destroy_yakushoku").addClass("disabled");
              #     failure: () ->
              #       console.log("yakushoku_削除する keydown Unsuccessful")
              #       $("#edit_yakushoku").removeClass("disabled");
              #       $("#destroy_yakushoku").removeClass("disabled");

              #   })

              # else
              #   $("#edit_yakushoku").attr("disabled", false)
              #   $("#destroy_yakushoku").attr("disabled", false)
          failure: () ->
            console.log("yakushoku_before_destroy keydown Unsuccessful")
            $("#edit_yakushoku").removeClass("disabled");
            $("#destroy_yakushoku").removeClass("disabled");

        })


  $('#new_yakushoku').click () ->
    $('#yakushoku-new-modal').modal('show')
    $('#yakushokumaster_役職コード').val('')
    $('#yakushokumaster_役職名').val('')

    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_yakushoku').click () ->
    yakushoku = oTable.row('tr.selected').data()
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );
    if yakushoku == undefined
      swal("行を選択してください。")
    else
      $('#yakushoku-edit-modal').modal('show')
      $('#yakushokumaster_役職コード').val(yakushoku[0])
      $('#yakushokumaster_役職名').val(yakushoku[1])

