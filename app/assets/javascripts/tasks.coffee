# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
 
  $('#new_task').click () ->
    $('#task-new-modal').modal('show')
    $('#task.title').val('')
    $('#task.description').val('')
    $('.form-group.has-error').each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );

  $('#edit_task').click () ->
    $('#task-edit-modal').modal('show')
    