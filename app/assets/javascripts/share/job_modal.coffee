jQuery ->
  table = $('#job_table').DataTable
    retrieve: true
    pagingType: 'full_numbers'
    oLanguage:
      sUrl: '/assets/resource/dataTable_' + $('#language').text() + '.txt'

  $('#job_table tbody').on 'click', 'tr', ()->
    if $(this).hasClass('selected')
      $(this).removeClass('selected')
    else
      table.$('tr.selected').removeClass('selected')
      $(this).addClass('selected')

  $('#job_sentaku_ok').click ()->
    selected_data = table.row('tr.selected').data()
    $('#job_table').trigger 'choose_job', [selected_data]

  $('#job_table tbody').on 'dblclick', 'tr', ()->
    $(this).addClass('selected')
    selected_data = table.row('tr.selected').data()
    $('#job_table').trigger 'choose_job', [selected_data]
    $('#job_search_modal').modal('hide')
