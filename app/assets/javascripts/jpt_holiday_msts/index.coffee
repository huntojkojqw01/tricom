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
    $('#jpt_holiday_mst_event_date').val('')
    $('#jpt_holiday_mst_title').val('')
    $('#jpt_holiday_mst_description').val('')
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#holiday-edit-modal').on 'show', (e, selected_row_data)->
    $(this).modal('show')
    $('#jpt_holiday_mst_id').val(selected_row_data[0])
    $('#jpt_holiday_mst_event_date').val(selected_row_data[1])
    $('#jpt_holiday_mst_title').val(selected_row_data[2])
    $('#jpt_holiday_mst_description').val(selected_row_data[3])
    $('.form-group.has-error').each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')

  $('#holiday-new-modal .jpt_holiday_mst_休日 > .input-group').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false
  $('#holiday-new-modal #jpt_holiday_mst_event_date').click ()->
    $('#holiday-new-modal .jpt_holiday_mst_休日 > .input-group').data('DateTimePicker').toggle()
  $('#holiday-edit-modal .jpt_holiday_mst_休日 > .input-group').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false
  $('#holiday-edit-modal #jpt_holiday_mst_event_date').click ()->
    $('#holiday-edit-modal .jpt_holiday_mst_休日 > .input-group').data('DateTimePicker').toggle()
