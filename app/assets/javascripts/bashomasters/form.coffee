jQuery ->
  $('.refer-kaisha').click ()->
    $('#kaisha-search-modal').trigger('show', [$('#bashomaster_会社コード').val()])

  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#bashomaster_会社コード').val(selected_data[0])
      $('#bashomaster_会社コード').closest('.form-group').find('span.help-block').remove()
      $('#bashomaster_会社コード').closest('.form-group').removeClass('has-error')

  $('#bashomaster_会社コード').keydown (e) ->
    if (e.keyCode == 9 && !e.shiftKey)
      kaisha_code = $('#bashomaster_会社コード').val()
      oKaisha_modal = $('#kaisha-table-modal').DataTable()
      row_can_tim = oKaisha_modal.row (idx, data, node) ->
        if data[0] == kaisha_code then true else false
      if row_can_tim.length > 0
        $('.kaisha-name').text(row_can_tim.data()[1])
      else
        $('.kaisha-name').text('')