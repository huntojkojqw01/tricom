# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oTable = $('.rorumaster-table').DataTable({
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    "fnDrawCallback": (oSettings) ->
      $('.new-btn').appendTo($('.dt-buttons'));
      $('.edit-btn').appendTo($('.dt-buttons'));
      $('.delete-btn').appendTo($('.dt-buttons'));
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
                  $("#edit_rorumaster").attr("disabled", true);
                  $("#destroy_rorumaster").attr("disabled", true);
                else
                  $("#destroy_rorumaster").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_rorumaster").attr("disabled", false);
                  else
                    $("#edit_rorumaster").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_rorumaster").attr("disabled", true);
                  $("#destroy_rorumaster").attr("disabled", true);
                else
                  $("#destroy_rorumaster").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_rorumaster").attr("disabled", false);
                  else
                    $("#edit_rorumaster").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]
  })


  $("#edit_rorumaster").attr("disabled", true);
  $("#destroy_rorumaster").attr("disabled", true);

  $(document).bind('ajaxError', 'form#new_rorumaster', (event, jqxhr, settings, exception) ->
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
  $('.rorumaster-table').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_rorumaster").attr("disabled", true);
        # $("#destroy_rorumaster").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_rorumaster").attr("disabled", false);
        # $("#destroy_rorumaster").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_rorumaster").attr("disabled", true);
      $("#destroy_rorumaster").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_rorumaster").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_rorumaster").attr("disabled", false);
      else
        $("#edit_rorumaster").attr("disabled", true);
  )

  $('#destroy_rorumaster').click () ->
    rorus = oTable.rows('tr.selected').data()
    roruIds = new Array();
    if rorus.length == 0
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
        len = rorus.length
        for i in [0...len]
          roruIds[i] = rorus[i][0]

        $.ajax({
          url: '/rorumasters/ajax',
          data:{
            focus_field: 'rorumaster_削除する',
            rorus: roruIds
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
            console.log("rorumaster_削除する keydown Unsuccessful")

        })
        $("#edit_rorumaster").attr("disabled", true);
        $("#destroy_rorumaster").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_rorumaster").attr("disabled", true);
            $("#destroy_rorumaster").attr("disabled", true);
          else
            $("#destroy_rorumaster").attr("disabled", false);
            if selects.length == 1
              $("#edit_rorumaster").attr("disabled", false);
            else
              $("#edit_rorumaster").attr("disabled", true);
      );

  $('#new_rorumaster').click () ->
    $('#roru-new-modal').modal('show')
    $('#rorumaster_ロールコード').val('')
    $('#rorumaster_ロール名').val('')
    $('#rorumaster_序列').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_rorumaster').click () ->
    roru_id = oTable.row('tr.selected').data()
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );
    if roru_id == undefined
      swal("行を選択してください。")
    else
      $('#roru-edit-modal').modal('show')
      $('#rorumaster_ロールコード').val(roru_id[0])
      $('#rorumaster_ロール名').val(roru_id[1])
      $('#rorumaster_序列').val(roru_id[2])
