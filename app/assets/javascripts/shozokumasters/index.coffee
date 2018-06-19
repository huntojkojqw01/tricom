jQuery ->
  create_datatable
    table_id: '#shozokumaster'
    new_modal_id: '#shozoku-new-modal'
    edit_modal_id: '#shozoku-edit-modal'
    delete_path: '/shozokumasters/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#shozoku-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#shozokumaster_所属コード').val('')
    $('#shozokumaster_所属名').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#shozoku-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#shozokumaster_所属コード').val(selected_row_data[0])
    $('#shozokumaster_所属名').val(selected_row_data[1])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
