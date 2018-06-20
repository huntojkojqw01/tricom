jQuery ->
  create_datatable
    table_id: '#kikanmaster'
    new_modal_id: '#kikan-new-modal'
    edit_modal_id: '#kikan-edit-modal'
    delete_path: '/kikanmsts/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#kikan-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#kikanmst_機関コード').val('')
    $('#kikanmst_機関名').val('')
    $('#kikanmst_備考').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#kikan-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#kikanmst_機関コード').val(selected_row_data[0])
    $('#kikanmst_機関名').val(selected_row_data[1])
    $('#kikanmst_備考').val(selected_row_data[2])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
