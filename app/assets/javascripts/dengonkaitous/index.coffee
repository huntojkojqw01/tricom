jQuery ->
  create_datatable
    table_id: '#dengonkaitoumaster'
    new_modal_id: '#dengonkaitou-new-modal'
    edit_modal_id: '#dengonkaitou-edit-modal'
    delete_path: '/dengonkaitous/id'
    invisible_columns: [0]
    no_search_columns: [0]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#dengonkaitou-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#dengonkaitou_種類名').val('')
    $('#dengonkaitou_備考').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#dengonkaitou-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#dengonkaitou_id').val(selected_row_data[0])
    $('#dengonkaitou_種類名').val(selected_row_data[1])
    $('#dengonkaitou_備考').val(selected_row_data[2])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
