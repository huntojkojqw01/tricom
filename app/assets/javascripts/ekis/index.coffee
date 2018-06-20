jQuery ->
  create_datatable
    table_id: '#ekimaster'
    new_modal_id: '#eki-new-modal'
    edit_modal_id: '#eki-edit-modal'
    delete_path: '/ekis/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#eki-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#eki_駅コード').val('')
    $('#eki_駅名').val('')
    $('#eki_駅名カナ').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#eki-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#eki_駅コード').val(selected_row_data[0])
    $('#eki_駅名').val(selected_row_data[1])
    $('#eki_駅名カナ').val(selected_row_data[2])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
