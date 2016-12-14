jQuery ->
  $(document).on 'click', '.refer-shozoku', (event) ->
    $('#select_shozoku_modal').modal('show')

  oShozokuTable = $('#shozoku_search_table').DataTable({
    "pagingType": "full_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
  })

#  選択された行を判断
  $('#shozoku_search_table tbody').on( 'click', 'tr', () ->
    d = oShozokuTable.row(this).data()
    $('#kouteimaster_所属コード').val(d[0])
    $('.shozoku-code-hint').text(d[1])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShozokuTable.$('tr.selected').removeClass('selected')
      oShozokuTable.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )
