jQuery ->
  create_datatable
    table_id: '#setsubimaster'
    new_modal_id: '#setsubi-new-modal'
    edit_modal_id: '#setsubi-edit-modal'
    delete_path: '/setsubis/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#setsubi-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#setsubi_設備コード').val('')
    $('#setsubi_設備名').val('')
    $('#setsubi_備考').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#setsubi-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#setsubi_設備コード').val(selected_row_data[0])
    $('#setsubi_設備名').val(selected_row_data[1])
    $('#setsubi_備考').val(selected_row_data[2])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
