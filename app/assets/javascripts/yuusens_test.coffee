# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.yuusen-table').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
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
                  $("#edit_yuusen").attr("disabled", true);
                  $("#destroy_yuusen").attr("disabled", true);
                else
                  $("#destroy_yuusen").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_yuusen").attr("disabled", false);
                  else
                    $("#edit_yuusen").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_yuusen").attr("disabled", true);
                  $("#destroy_yuusen").attr("disabled", true);
                else
                  $("#destroy_yuusen").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_yuusen").attr("disabled", false);
                  else
                    $("#edit_yuusen").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]
  })

  $("#edit_yuusen").attr("disabled", true);
  $("#destroy_yuusen").attr("disabled", true);

  $(document).bind('ajaxError', 'form#new_yuusen', (event, jqxhr, settings, exception) ->
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
    
  $('.yuusen-table').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_yuusen").attr("disabled", true);
        # $("#destroy_yuusen").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_yuusen").attr("disabled", false);
        # $("#destroy_yuusen").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_yuusen").attr("disabled", true);
      $("#destroy_yuusen").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_yuusen").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_yuusen").attr("disabled", false);
      else
        $("#edit_yuusen").attr("disabled", true);
  )

  $('#destroy_yuusen').click () ->
    yuusens = oTable.rows('tr.selected').data()
    yuusenIds = new Array();
    if yuusens.length == 0
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
        len = yuusens.length
        for i in [0...len]
          yuusenIds[i] = yuusens[i][0]

        $.ajax({
          url: '/yuusens/ajax',
          data:{
            focus_field: 'yuusen_削除する',
            yuusens: yuusenIds
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
            console.log("yuusen_削除する keydown Unsuccessful")

        })
        $("#edit_yuusen").attr("disabled", true);
        $("#destroy_yuusen").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_yuusen").attr("disabled", true);
            $("#destroy_yuusen").attr("disabled", true);
          else
            $("#destroy_yuusen").attr("disabled", false);
            if selects.length == 1
              $("#edit_yuusen").attr("disabled", false);
            else
              $("#edit_yuusen").attr("disabled", true);
      );

  $('#edit_yuusen').click () ->
    yuusen_id = oTable.row('tr.selected').data()
    window.location = '/yuusens/' + yuusen_id[0] + '/edit?'

  $ ->
  $('#yuusen_色').colorpicker()
  $('#yuusen_色').colorpicker().on 'changeColor', (ev) ->
    $('#preview-backgroud').css 'background-color', ev.color.toHex()
    $(this).val ev.color.toHex()
    return
  $('#preview-backgroud').css 'background-color', $('#yuusen_色').val()
  return