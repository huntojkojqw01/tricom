jQuery ->
  $('.shain-table-mark').DataTable
    pagingType: "simple_numbers"
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
    select:
      style: 'multi'
    oSearch:
      sSearch: queryParameters().search
