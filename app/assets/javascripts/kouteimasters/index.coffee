jQuery ->
  create_datatable
    table_id: '#kouteimaster'
    new_modal_id: '#koutei-new-modal'
    edit_modal_id: '#koutei-edit-modal'
    delete_path: '/kouteimasters/id'
    page_length: parseInt($('#pageLength').text())
    invisible_columns: [0, 1]
    no_search_columns: [0, 1]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#koutei-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#kouteimaster_所属コード').val('')
    $('#kouteimaster_工程コード').val('')
    $('#kouteimaster_工程名').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#koutei-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#kouteimaster_所属コード').val(selected_row_data[1])
    $('#kouteimaster_工程コード').val(selected_row_data[3])
    $('#kouteimaster_工程名').val(selected_row_data[4])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#kouteimaster').on 'length.dt', (e, settings, len)->
    $.post( "/settings/ajax", { setting: 'setting_page_len', page_len: len } )
      .done (data)->
        console.log("Page length changed to " + data) 