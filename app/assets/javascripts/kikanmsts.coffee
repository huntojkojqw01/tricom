# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oKikanTable = $('.kikantable').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
    ,"oSearch": {"sSearch": queryParameters().search}
  })

  $("#edit_kikan").attr("disabled", true);
  $("#destroy_kikan").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_kikanmst', (event, jqxhr, settings, exception) ->
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


  $('.kikantable').on( 'click', 'tr',  () ->
    d = oKikanTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        $("#edit_kikan").attr("disabled", true);
        $("#destroy_kikan").attr("disabled", true);
      else
        oKikanTable.$('tr.selected').removeClass('selected')
        oKikanTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        $("#edit_kikan").attr("disabled", false);
        $("#destroy_kikan").attr("disabled", false);
  )

  $('#destroy_kikan').click () ->
    kikan = oKikanTable.row('tr.selected').data()

    if kikan == undefined
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
        $.ajax({
          url: '/kikanmsts/ajax',
          data:{
            focus_field: 'kikan_削除する',
            kikan_id: kikan[0]
          },

          type: "POST",

          success: (data) ->
            swal("削除されました!", "", "success");
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              oKikanTable.rows('tr.selected').remove().draw();
              # $(".kikantable").dataTable().fnDeleteRow($('.kikantable').find('tr.selected').remove())
              # $(".kikantable").dataTable().fnDraw()
              $("#edit_kikan").attr("disabled", true);
              $("#destroy_kikan").attr("disabled", true);
          failure: () ->
            console.log("kikan_削除する keydown Unsuccessful")
            $("#edit_kikan").attr("disabled", false);
            $("#destroy_kikan").attr("disabled", false);

        })
      ,(dismiss) ->
        if dismiss == 'cancel'
          $("#edit_kikan").attr("disabled", false)
          $("#destroy_kikan").attr("disabled", false)
      );
      # response = confirm($('#message_confirm_delete').text())
      # if response
      #   $.ajax({
      #     url: '/kikanmsts/ajax',
      #     data:{
      #       focus_field: 'kikan_削除する',
      #       kikan_id: kikan[0]
      #     },

      #     type: "POST",

      #     success: (data) ->
      #       if data.destroy_success != null
      #         console.log("getAjax destroy_success:"+ data.destroy_success)
      #         $(".kikantable").dataTable().fnDeleteRow($('.kikantable').find('tr.selected').remove())
      #         $(".kikantable").dataTable().fnDraw()
      #         $("#edit_kikan").attr("disabled", true);
      #         $("#destroy_kikan").attr("disabled", true);
      #     failure: () ->
      #       console.log("kikan_削除する keydown Unsuccessful")
      #       $("#edit_kikan").attr("disabled", false);
      #       $("#destroy_kikan").attr("disabled", false);

      #   })

      # else
      #   $("#edit_kikan").attr("disabled", false)
      #   $("#destroy_kikan").attr("disabled", false)


  $('#new_kikan').click () ->
    $('#kikan-new-modal').modal('show')
    $('#kikanmst_機関コード').val('')
    $('#kikanmst_機関名').val('')
    $('#kikanmst_備考').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_kikan').click () ->
    kikan= oKikanTable.row('tr.selected').data()
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );
    if kikan == undefined
      swal("行を選択してください。")
    else
      $('#kikan-edit-modal').modal('show')
      $('#kikanmst_機関コード').val(kikan[0])
      $('#kikanmst_機関名').val(kikan[1])
      $('#kikanmst_備考').val(kikan[2])
