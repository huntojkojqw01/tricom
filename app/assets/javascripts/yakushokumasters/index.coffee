jQuery ->
  create_datatable
    table_id: '#yakushokumaster'
    new_modal_id: '#yakushoku-new-modal'
    edit_modal_id: '#yakushoku-edit-modal'
    delete_path: '/yakushokumasters/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#yakushoku-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#yakushokumaster_役職コード').val('')
    $('#yakushokumaster_役職名').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#yakushoku-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#yakushokumaster_役職コード').val(selected_row_data[0])
    $('#yakushokumaster_役職名').val(selected_row_data[1])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
