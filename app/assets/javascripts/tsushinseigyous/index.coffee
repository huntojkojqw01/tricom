jQuery ->
  create_datatable
    table_id: '#tsushinseigyoumaster'
    new_modal_id: '#tsushinseigyou-new-modal'
    edit_modal_id: '#tsushinseigyou-edit-modal'
    delete_path: '/tsushinseigyous/id'
    invisible_columns: [0]
    no_search_columns: [0]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#tsushinseigyou-new-modal').on 'show', ()->
    $(this).modal('show')
    $('#tsushinseigyou_社員番号').val('')
    $('#tsushinseigyou_メール').val('')
    $('#tsushinseigyou_送信許可区分').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#tsushinseigyou-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#tsushinseigyou_id').val(selected_row_data[0])
    $('#tsushinseigyou_社員番号').val(selected_row_data[1])
    $('#tsushinseigyou_メール').val(selected_row_data[2])
    $('#tsushinseigyou_送信許可区分').val(if selected_row_data[3] == '許可' then '1' else '0')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
