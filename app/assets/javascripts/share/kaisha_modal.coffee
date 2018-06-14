jQuery ->
  table = $('#kaisha-table-modal').DataTable
    retrieve: true
    pagingType: 'full_numbers'
    oLanguage:
      sUrl: '/assets/resource/dataTable_' + $('#language').text() + '.txt'

  $('#kaisha-table-modal tbody').on 'click', 'tr', ()->
    if $(this).hasClass('selected')
      $(this).removeClass('selected')
    else
      table.$('tr.selected').removeClass('selected')
      $(this).addClass('selected')

  $('#kaisha_sentaku_ok').click ()->
    selected_data = table.row('tr.selected').data()
    $('#kaisha-table-modal').trigger 'choose_kaisha', [selected_data]

  $('#kaisha-table-modal tbody').on 'dblclick', 'tr', ()->
    $(this).addClass('selected')
    selected_data = table.row('tr.selected').data()
    $('#kaisha-table-modal').trigger 'choose_kaisha', [selected_data]
    $('#kaisha-search-modal').modal('hide')
