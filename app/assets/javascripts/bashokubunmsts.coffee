# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.bashokubunmsttable').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,"oSearch": {"sSearch": queryParameters().search},
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
                  $("#edit_bashokubunmst").attr("disabled", true);
                  $("#destroy_bashokubunmst").attr("disabled", true);
                else
                  $("#destroy_bashokubunmst").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_bashokubunmst").attr("disabled", false);
                  else
                    $("#edit_bashokubunmst").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_bashokubunmst").attr("disabled", true);
                  $("#destroy_bashokubunmst").attr("disabled", true);
                else
                  $("#destroy_bashokubunmst").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_bashokubunmst").attr("disabled", false);
                  else
                    $("#edit_bashokubunmst").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]
  })
  $("#edit_bashokubunmst").attr("disabled", true);
  $("#destroy_bashokubunmst").attr("disabled", true);

  $(document).bind('ajaxError', 'form#new_bashokubunmst', (event, jqxhr, settings, exception) ->
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
  $('.bashokubunmsttable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_bashokubunmst").attr("disabled", true);
        # $("#destroy_bashokubunmst").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_bashokubunmst").attr("disabled", false);
        # $("#destroy_bashokubunmst").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_bashokubunmst").attr("disabled", true);
      $("#destroy_bashokubunmst").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_bashokubunmst").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_bashokubunmst").attr("disabled", false);
      else
        $("#edit_bashokubunmst").attr("disabled", true);
  )

  $('#destroy_bashokubunmst').click () ->
    bashokubunmsts = oTable.rows('tr.selected').data()
    bashokubunmstIds = new Array();
    if bashokubunmsts.length == 0
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
        len = bashokubunmsts.length
        for i in [0...len]
          bashokubunmstIds[i] = bashokubunmsts[i][0]

        $.ajax({
          url: '/bashokubunmsts/ajax',
          data:{
            focus_field: 'bashokubunmst_削除する',
            bashokubunmsts: bashokubunmstIds
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
            console.log("bashokubunmst_削除する keydown Unsuccessful")

        })
        $("#edit_bashokubunmst").attr("disabled", true);
        $("#destroy_bashokubunmst").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_bashokubunmst").attr("disabled", true);
            $("#destroy_bashokubunmst").attr("disabled", true);
          else
            $("#destroy_bashokubunmst").attr("disabled", false);
            if selects.length == 1
              $("#edit_bashokubunmst").attr("disabled", false);
            else
              $("#edit_bashokubunmst").attr("disabled", true);
      );
  
  $('#new_bashokubunmst').click () ->
    $('#bashokubunmst-new-modal').modal('show')
    $('#bashokubunmst_場所区分コード').val('')
    $('#bashokubunmst_場所区分名').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_bashokubunmst').click () ->
    bashokubunmst_id = oTable.row('tr.selected').data()
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );
    if bashokubunmst_id == undefined
      swal("行を選択してください。")
    else
    $('#bashokubunmst-edit-modal').modal('show')
    $('#bashokubunmst_場所区分コード').val(bashokubunmst_id[0])
    $('#bashokubunmst_場所区分名').val(bashokubunmst_id[1])
