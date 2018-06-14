jQuery ->  
  $('.myjobmaster_開始日 > .form-inline > .date').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false

  $('#myjobmaster_開始日').click () ->
    $('.myjobmaster_開始日 > .form-inline > .date').data("DateTimePicker").toggle()

  $('.myjobmaster_終了日 > .form-inline > .date').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    keyBinds: false
    focusOnShow: false

  $('#myjobmaster_終了日').click ()->
    $('.myjobmaster_終了日 > .form-inline > .date').data("DateTimePicker").toggle()

  $('.search-field').click ()->
    switch $(this).prev().attr('id')
      when 'myjobmaster_ユーザ番号' then $('#kaisha-search-modal').modal('show')
      when 'myjobmaster_入力社員番号' then $('#select_user_modal_refer').modal('show')
      when 'myjobmaster_関連Job番号' then $('#job_search_modal').modal('show')

  $('#myjobmaster_ユーザ番号').keydown (e)->
    if (e.keyCode == 9 && !e.shiftKey)
      kaisha_code = $('#myjobmaster_ユーザ番号').val()
      oKaisha_modal = $('#kaisha-table-modal').DataTable()
      row_can_tim = oKaisha_modal.row (idx, data, node)->
        if data[0] == kaisha_code then true else false
      if row_can_tim.length > 0
        $('#myjobmaster_ユーザ名').val(row_can_tim.data()[1])
      else
        $('#myjobmaster_ユーザ名').val('')      
  
  $('#kaisha-table-modal').on 'choose_kaisha', (e, selected_data)->
    if selected_data != undefined
      $('#myjobmaster_ユーザ番号').val(selected_data[0])
      $('#myjobmaster_ユーザ名').val(selected_data[1])
      $('#myjobmaster_ユーザ番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_ユーザ番号').closest('.form-group').removeClass('has-error')

  $('#user_table').on 'choose_shain', (e, selected_data)->
    if selected_data != undefined
      $('#myjobmaster_入力社員番号').val(selected_data[0])
      $('.hint-shain-refer').text(selected_data[1])
      $('#myjobmaster_入力社員番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_入力社員番号').closest('.form-group').removeClass('has-error')

  $('#job_table').on 'choose_job', (e, selected_data)->
    if selected_data != undefined
      $('#myjobmaster_関連Job番号').val(selected_data[0])
      $('.hint-job-refer').text(selected_data[1])
      $('#myjobmaster_関連Job番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_関連Job番号').closest('.form-group').removeClass('has-error')
