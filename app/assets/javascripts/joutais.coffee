# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('#joutaimaster').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "columnDefs": [{
      "targets"  : 'no-sort',
      "orderable": false
    }],
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
                  $("#edit_joutai").attr("disabled", true);
                  $("#destroy_joutai").attr("disabled", true);
                else
                  $("#destroy_joutai").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_joutai").attr("disabled", false);
                  else
                    $("#edit_joutai").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_joutai").attr("disabled", true);
                  $("#destroy_joutai").attr("disabled", true);
                else
                  $("#destroy_joutai").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_joutai").attr("disabled", false);
                  else
                    $("#edit_joutai").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]
  })


  $("#edit_joutai").attr("disabled", true);
  $("#destroy_joutai").attr("disabled", true);

  $(document).bind('ajaxError', 'form#new_joutaimaster', (event, jqxhr, settings, exception) ->
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
  $('#joutaimaster').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_joutai").attr("disabled", true);
        # $("#destroy_joutai").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_joutai").attr("disabled", false);
        # $("#destroy_joutai").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_joutai").attr("disabled", true);
      $("#destroy_joutai").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_joutai").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_joutai").attr("disabled", false);
      else
        $("#edit_joutai").attr("disabled", true);
  )

  $('#destroy_joutai').click () ->
    joutais = oTable.rows('tr.selected').data()
    joutaiIds = new Array();
    if joutais.length == 0
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
        len = joutais.length
        for i in [0...len]
          joutaiIds[i] = joutais[i][0]

        $.ajax({
          url: '/joutaimasters/ajax',
          data:{
            focus_field: 'joutaimaster_削除する',
            joutais: joutaiIds
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
            console.log("joutai_削除する keydown Unsuccessful")

        })
        $("#edit_joutai").attr("disabled", true);
        $("#destroy_joutai").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_joutai").attr("disabled", true);
            $("#destroy_joutai").attr("disabled", true);
          else
            $("#destroy_joutai").attr("disabled", false);
            if selects.length == 1
              $("#edit_joutai").attr("disabled", false);
            else
              $("#edit_joutai").attr("disabled", true);
      );
  
  $('#new_joutai').click () ->
    $('#joutai-new-modal').modal('show')
    $('#joutai_ロールコード').val('')
    $('#joutai_ロール名').val('')
    $('#joutai_序列').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_joutai').click () ->
    joutaimasters_id = oTable.row('tr.selected').data()
    window.location = '/joutaimasters/' + joutaimasters_id[0] + '/edit?'

$ ->
  $('#joutaimaster_色').colorpicker()
  $('#joutaimaster_text_color').colorpicker()
  $('#joutaimaster_色').colorpicker().on 'changeColor', (ev) ->
    $('#preview-backgroud').css 'background-color', ev.color.toHex()
    $(this).val ev.color.toHex()
    return
  $('#joutaimaster_text_color').colorpicker().on 'changeColor', (ev) ->
    $('#preview-text').css 'color', ev.color.toHex()
    $(this).val ev.color.toHex()
    return
  #binding preview when load
  $('#preview-text').css 'color', $('#joutaimaster_text_color').val()
  $('#preview-backgroud').css 'background-color', $('#joutaimaster_色').val()
  return
