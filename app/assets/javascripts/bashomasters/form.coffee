jQuery ->
  $('.refer-kaisha').click ()->
    $('#kaisha-search-modal').trigger('show', [$('#bashomaster_会社コード').val()])

  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#bashomaster_会社コード').val(selected_data[0])
      $('#bashomaster_会社コード').closest('.form-group').find('span.help-block').remove()
      $('#bashomaster_会社コード').closest('.form-group').removeClass('has-error')
