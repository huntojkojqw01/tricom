jQuery ->
  create_datatable
    table_id: '#bashokubunmst_table'
    new_modal_id: '#bashokubunmst-new-modal'
    edit_modal_id: '#bashokubunmst-edit-modal'
    delete_path: '/bashokubunmsts/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#bashokubunmst-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#bashokubunmst_場所区分コード').val('')
    $('#bashokubunmst_場所区分名').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#bashokubunmst-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#bashokubunmst_場所区分コード').val(selected_row_data[0])
    $('#bashokubunmst_場所区分名').val(selected_row_data[1])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
