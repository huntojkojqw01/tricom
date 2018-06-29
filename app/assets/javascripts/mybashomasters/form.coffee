jQuery ->
  $('.refer-kaisha').click ()->
    $('#kaisha-search-modal').trigger('show', [$('#mybashomaster_会社コード').val()])

  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#mybashomaster_会社コード').val(selected_data[0])
      $('.kaisha-name').text(selected_data[1])
      $('#mybashomaster_会社コード').closest('.form-group').find('span.help-block').remove()
      $('#mybashomaster_会社コード').closest('.form-group').removeClass('has-error')

  setup_tab_render_name
    input: $('#mybashomaster_会社コード')
    output: $('.kaisha-name')
    table: $('#kaisha-table-modal')
