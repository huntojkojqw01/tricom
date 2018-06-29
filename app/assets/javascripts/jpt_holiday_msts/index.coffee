jQuery ->
  create_datatable
    table_id: '#holiday_table'
    new_modal_id: '#holiday-new-modal'
    edit_modal_id: '#holiday-edit-modal'
    delete_path: '/jpt_holiday_msts/id'
    invisible_columns: [0]
    no_search_columns: [0]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]

  $('#holiday-new-modal').on 'show', ()->
    $(this).modal('show')
    $(this).find('#jpt_holiday_mst_event_date').val('')
    $(this).find('#jpt_holiday_mst_title').val('')
    $(this).find('#jpt_holiday_mst_description').val('')
    $(this).find('form').clear_previous_errors()

  $('#holiday-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $(this).find('#jpt_holiday_mst_id').val(selected_row_data[0])
    $(this).find('#jpt_holiday_mst_event_date').val(selected_row_data[1])
    $(this).find('#jpt_holiday_mst_title').val(selected_row_data[2])
    $(this).find('#jpt_holiday_mst_description').val(selected_row_data[3])
    $(this).find('form').clear_previous_errors()

  $('.datetime').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false
  $('#holiday-new-modal #jpt_holiday_mst_event_date').click ()->
    $('#holiday-new-modal .datetime').data('DateTimePicker').toggle()
  $('#holiday-edit-modal #jpt_holiday_mst_event_date').click ()->
    $('#holiday-edit-modal .datetime').data('DateTimePicker').toggle()
