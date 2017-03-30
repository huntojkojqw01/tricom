# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $('#new_task').click () ->
    $('#task-new-modal').modal('show')
    $('#task_title').val('')
    $('#task_description').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_task').click () ->
    $('#task-edit-modal').modal('show')

  $(document).bind('ajaxError', 'form#new_task', (event, jqxhr, settings, exception) ->
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

  $(document).on('click', '.destroy-task', (e) ->

    task_id = $(this).attr('id')
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
          url: '/tasks/ajax',
          data:{
            focus_field: 'task_削除する',
            task_id: task_id
          },

          type: "POST",

          success: (data) ->
            swal("削除されました!", "", "success");
            $('#task'+task_id).remove();


          failure: () ->
            console.log("task_削除する keydown Unsuccessful")

        })
      );
  )

  $(document).on('click', '.change-status', (e) ->

    task_id = $(this).attr('task-id')

    $.ajax({
      url: '/tasks/ajax',
      data:{
        focus_field: 'change_status',
        task_id: task_id
      },

      type: "POST",

      success: (data) ->
         console.log("Successful")
      failure: () ->
        console.log("Unsuccessful")

    })

  )
