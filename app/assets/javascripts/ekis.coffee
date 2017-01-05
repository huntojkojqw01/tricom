# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oEkiTable = $('.ekitable').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }],


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
                oEkiTable.$('tr').addClass('selected')
                oEkiTable.$('tr').addClass('success')
                selects = oEkiTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_eki").attr("disabled", true);
                  $("#destroy_eki").attr("disabled", true);
                else
                  $("#destroy_eki").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_eki").attr("disabled", false);
                  else
                    $("#edit_eki").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oEkiTable.$('tr').removeClass('selected')
                oEkiTable.$('tr').removeClass('success')
                selects = oEkiTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_eki").attr("disabled", true);
                  $("#destroy_eki").attr("disabled", true);
                else
                  $("#destroy_eki").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_eki").attr("disabled", false);
                  else
                    $("#edit_eki").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_eki").attr("disabled", true);
  $("#destroy_eki").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_eki', (event, jqxhr, settings, exception) ->
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


  $('.ekitable').on( 'click', 'tr',  () ->
    d = oEkiTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_eki").attr("disabled", true);
        # $("#destroy_eki").attr("disabled", true);
      else
        # oEkiTable.$('tr.selected').removeClass('selected')
        # oEkiTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_eki").attr("disabled", false);
        # $("#destroy_eki").attr("disabled", false);
    selects = oEkiTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_eki").attr("disabled", true);
      $("#destroy_eki").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_eki").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_eki").attr("disabled", false);
      else
        $("#edit_eki").attr("disabled", true);

  )

  $('#destroy_eki').click () ->
    ekis = oEkiTable.rows('tr.selected').data()
    ekiIds = new Array();
    if ekis.length == 0
      alert($('#message_confirm_select').text())
    else
      response = confirm($('#message_confirm_delete').text())
      if response
        len = ekis.length
        for i in [0...len]
          ekiIds[i] = ekis[i][0]

        $.ajax({
          url: '/ekis/ajax',
          data:{
            focus_field: 'eki_削除する',
            ekis: ekiIds
          },

          type: "POST",

          success: (data) ->
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              $(".ekitable").dataTable().fnDeleteRow($('.ekitable').find('tr.selected').remove())
              $(".ekitable").dataTable().fnDraw()

            else
              console.log("getAjax destroy_success:"+ data.destroy_success)


          failure: () ->
            console.log("eki_削除する keydown Unsuccessful")

        })
        $("#edit_eki").attr("disabled", true);
        $("#destroy_eki").attr("disabled", true);
      else
        selects = oEkiTable.rows('tr.selected').data()
        if selects.length == 0
          $("#edit_eki").attr("disabled", true);
          $("#destroy_eki").attr("disabled", true);
        else
          $("#destroy_eki").attr("disabled", false);
          if selects.length == 1
            $("#edit_eki").attr("disabled", false);
          else
            $("#edit_eki").attr("disabled", true);


  $('#new_eki').click () ->
    $('#eki-new-modal').modal('show')
    $('#eki_駅コード').val('')
    $('#eki_駅名').val('')
    $('#eki_駅名カナ').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_eki').click () ->
    eki_id = oEkiTable.row('tr.selected').data()
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );
    if eki_id == undefined
      alert("行を選択してください。")
    else
      $('#eki-edit-modal').modal('show')
      $('#eki_駅コード').val(eki_id[0])
      $('#eki_駅名').val(eki_id[1])
      $('#eki_駅名カナ').val(eki_id[2])
