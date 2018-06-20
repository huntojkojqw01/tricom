jQuery ->
  create_datatable
    table_id: '#bunrui_table'
    new_modal_id: '#bunrui-new-modal'
    edit_modal_id: '#bunrui-edit-modal'
    delete_path: '/bunruis/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#bunrui-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#bunrui_分類コード').val('')
    $('#bunrui_分類名').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#bunrui-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#bunrui_分類コード').val(selected_row_data[0])
    $('#bunrui_分類名').val(selected_row_data[1])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
