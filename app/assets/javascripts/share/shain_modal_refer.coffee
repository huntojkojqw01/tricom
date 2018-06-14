jQuery ->
  table = $('#user_table').DataTable
    retrieve: true
    pagingType: 'full_numbers'
    oLanguage:
      sUrl: '/assets/resource/dataTable_' + $('#language').text() + '.txt'

  $('#user_table tbody').on 'click', 'tr', ()->
    if $(this).hasClass('selected')
      $(this).removeClass('selected')
    else
      table.$('tr.selected').removeClass('selected')
      $(this).addClass('selected')

  $('#user_refer_sentaku_ok').click ()->
    selected_data = table.row('tr.selected').data()
    $('#user_table').trigger 'choose_shain', [selected_data]

  $('#user_table tbody').on 'dblclick', 'tr', ()->
    $(this).addClass('selected')
    selected_data = table.row('tr.selected').data()
    $('#user_table').trigger 'choose_shain', [selected_data]
    $('#select_user_modal_refer').modal('hide')
