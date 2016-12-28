# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oEkiTable = $('.ekitable').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
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
        $("#edit_eki").attr("disabled", true);
        $("#destroy_eki").attr("disabled", true);
      else
        oEkiTable.$('tr.selected').removeClass('selected')
        oEkiTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        $("#edit_eki").attr("disabled", false);
        $("#destroy_eki").attr("disabled", false);
  )

  $('#destroy_eki').click () ->
    eki_id = oEkiTable.row('tr.selected').data()

    if eki_id == undefined
      alert($('#message_confirm_select').text())
    else
      response = confirm($('#message_confirm_delete').text())
      if response
        $.ajax({
          url: '/ekis/ajax',
          data:{
            focus_field: 'eki_削除する',
            eki_id: eki_id[0]
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
        $("#edit_eki").attr("disabled", false)
        $("#destroy_eki").attr("disabled", false)


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
