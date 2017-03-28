# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.dengonyoukentable').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
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
                  $("#edit_dengonyouken").attr("disabled", true);
                  $("#destroy_dengonyouken").attr("disabled", true);
                else
                  $("#destroy_dengonyouken").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_dengonyouken").attr("disabled", false);
                  else
                    $("#edit_dengonyouken").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_dengonyouken").attr("disabled", true);
                  $("#destroy_dengonyouken").attr("disabled", true);
                else
                  $("#destroy_dengonyouken").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_dengonyouken").attr("disabled", false);
                  else
                    $("#edit_dengonyouken").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]
  })
  $("#edit_dengonyouken").attr("disabled", true);
  $("#destroy_dengonyouken").attr("disabled", true);

  $(document).bind('ajaxError', 'form#new_dengonyouken', (event, jqxhr, settings, exception) ->
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
  $('.dengonyoukentable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_dengonyouken").attr("disabled", true);
        # $("#destroy_dengonyouken").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_dengonyouken").attr("disabled", false);
        # $("#destroy_dengonyouken").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_dengonyouken").attr("disabled", true);
      $("#destroy_dengonyouken").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_dengonyouken").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_dengonyouken").attr("disabled", false);
      else
        $("#edit_dengonyouken").attr("disabled", true);
  )

  $('#destroy_dengonyouken').click () ->
    dengonyoukens = oTable.rows('tr.selected').data()
    dengonyoukenIds = new Array();
    if dengonyoukens.length == 0
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
        len = dengonyoukens.length
        for i in [0...len]
          dengonyoukenIds[i] = dengonyoukens[i][0]

        $.ajax({
          url: '/dengonyoukens/ajax',
          data:{
            focus_field: 'dengonyouken_削除する',
            dengonyoukens: dengonyoukenIds
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
            console.log("dengonyouken_削除する keydown Unsuccessful")

        })
        $("#edit_dengonyouken").attr("disabled", true);
        $("#destroy_dengonyouken").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_dengonyouken").attr("disabled", true);
            $("#destroy_dengonyouken").attr("disabled", true);
          else
            $("#destroy_dengonyouken").attr("disabled", false);
            if selects.length == 1
              $("#edit_dengonyouken").attr("disabled", false);
            else
              $("#edit_dengonyouken").attr("disabled", true);
      );
  
  $('#new_dengonyouken').click () ->
    $('#dengonyouken-new-modal').modal('show')
    $('#dengonyouken_種類名').val('')
    $('#dengonyouken_備考').val('')
    $('#dengonyouken_優先さ').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_dengonyouken').click () ->
    dengonyouken_id = oTable.row('tr.selected').data()
    $('#dengonyouken-edit-modal').modal('show')
    $('#dengonyouken_種類名').val(dengonyouken_id[0])
    $('#dengonyouken_備考').val(dengonyouken_id[1])
    $('#dengonyouken_優先さ').val(dengonyouken_id[2])