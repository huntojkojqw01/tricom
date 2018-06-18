jQuery ->  
  $('.jobmaster_開始日 > .form-inline > .date').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false

  $('#jobmaster_開始日').click () ->
    $('.jobmaster_開始日 > .form-inline > .date').data("DateTimePicker").toggle()

  $('.jobmaster_終了日 > .form-inline > .date').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false

  $('#jobmaster_終了日').click ()->
    $('.jobmaster_終了日 > .form-inline > .date').data("DateTimePicker").toggle()

  $('.search-field').click ()->
    input = $(this).prev()
    switch input.attr('id')
      when 'jobmaster_ユーザ番号' then $('#kaisha-search-modal').trigger('show', [input.val()])
      when 'jobmaster_入力社員番号' then $('#select_user_modal_refer').trigger('show', [input.val()])
      when 'jobmaster_関連Job番号' then $('#job_search_modal').trigger('show', [input.val()])

  $('#jobmaster_ユーザ番号').keydown (e)->
    if (e.keyCode == 9 && !e.shiftKey)
      kaisha_code = $('#jobmaster_ユーザ番号').val()
      oKaisha_modal = $('#kaisha-table-modal').DataTable()
      row_can_tim = oKaisha_modal.row (idx, data, node)->
        if data[0] == kaisha_code then true else false
      if row_can_tim.length > 0
        $('#jobmaster_ユーザ名').val(row_can_tim.data()[1])
      else
        $('#jobmaster_ユーザ名').val('')      
  
  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#jobmaster_ユーザ番号').val(selected_data[0])
      $('#jobmaster_ユーザ名').val(selected_data[1])
      $('#jobmaster_ユーザ番号').closest('.form-group').find('span.help-block').remove()
      $('#jobmaster_ユーザ番号').closest('.form-group').removeClass('has-error')

  $('#user_table').on 'choose_shain', (e, selected_data)->
    if selected_data != undefined
      $('#jobmaster_入力社員番号').val(selected_data[0])
      $('.hint-shain-refer').text(selected_data[1])
      $('#jobmaster_入力社員番号').closest('.form-group').find('span.help-block').remove()
      $('#jobmaster_入力社員番号').closest('.form-group').removeClass('has-error')

  $('#job_table').on 'choose_job', (e, selected_data)->
    if selected_data != undefined
      $('#jobmaster_関連Job番号').val(selected_data[0])
      $('.hint-job-refer').text(selected_data[1])
      $('#jobmaster_関連Job番号').closest('.form-group').find('span.help-block').remove()
      $('#jobmaster_関連Job番号').closest('.form-group').removeClass('has-error')
