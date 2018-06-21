jQuery ->
  create_datatable
    table_id: '#dengonyoukenmaster'
    new_modal_id: '#dengonyouken-new-modal'
    edit_modal_id: '#dengonyouken-edit-modal'
    delete_path: '/dengonyoukens/id'
    invisible_columns: [0]
    no_search_columns: [0]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#dengonyouken-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#dengonyouken_種類名').val('')
    $('#dengonyouken_備考').val('')
    $('#dengonyouken_優先さ').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#dengonyouken-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#dengonyouken_id').val(selected_row_data[0])
    $('#dengonyouken_種類名').val(selected_row_data[1])
    $('#dengonyouken_備考').val(selected_row_data[2])
    $('#dengonyouken_優先さ').val(selected_row_data[3])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
