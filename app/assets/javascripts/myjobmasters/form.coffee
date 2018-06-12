jQuery ->
  oKaisha_modal = $('#kaisha-table-modal').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  oShain_modal = $('#user_table').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  oJob_modal = $('#job_table').DataTable({
    "pagingType": "full_numbers"
    , "oLanguage": {
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  $('#kaisha-table-modal tbody').on( 'click', 'tr',  () ->
    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKaisha_modal.$('tr.selected').removeClass('selected')
      oKaisha_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
   )

  $('#user_table tbody').on( 'click', 'tr',  () ->

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShain_modal.$('tr.selected').removeClass('selected')
      oShain_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )

  $('#job_table tbody').on( 'click', 'tr',  () ->
    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oJob_modal.$('tr.selected').removeClass('selected')
      oJob_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )

  $('.myjobmaster_開始日 > .form-inline > .date ').datetimepicker({
    format: 'YYYY/MM/DD',
    widgetPositioning: {
      horizontal: 'left',
    }
    showTodayButton: true,
    showClear: true,
    keyBinds: false,
    focusOnShow: false
  })

  $('.myjobmaster_開始日 > .form-inline > .date > .input-group-addon' ).click () ->
    $('.myjobmaster_開始日 > .form-inline > .date').data.toggle();

  $('#myjobmaster_開始日').click () ->
    $('.myjobmaster_開始日 > .form-inline > .date').data("DateTimePicker").toggle();


  $('.myjobmaster_終了日 > .form-inline > .date ').datetimepicker({
    format: 'YYYY/MM/DD',
    widgetPositioning: {
      horizontal: 'left',
    }
    showTodayButton: true,
    showClear: true,
    keyBinds: false,
    focusOnShow: false
  })

  $('.myjobmaster_終了日 > .form-inline > .date > .input-group-addon' ).click () ->
    $('.myjobmaster_終了日 > .form-inline > .date').data.toggle();

  $('#myjobmaster_終了日').click () ->
    $('.myjobmaster_終了日 > .form-inline > .date').data("DateTimePicker").toggle();

  $('.search-field').click( () ->
    element1 = $('.search-group').find('#myjobmaster_ユーザ番号')
    element2 = $('.search-group').find('#myjobmaster_入力社員番号')
    element3 = $('.search-group').find('#myjobmaster_関連Job番号')

    if $(this).prev().is(element1)
      $('#kaisha-search-modal').modal('show')

    if $(this).prev().is(element2)
      $('#select_user_modal_refer').modal('show')

    if $(this).prev().is(element3)
      $('#job_search_modal').modal('show')
  )

  $('#myjobmaster_ユーザ番号').keydown( (e) ->
    if (e.keyCode == 9 && !e.shiftKey)
      kaisha_code = $('#myjobmaster_ユーザ番号').val()
      row_can_tim = oKaisha_modal.row (idx, data, node)->
        if data[0] == kaisha_code then true else false
      if row_can_tim.length > 0
        $('#myjobmaster_ユーザ名').val(row_can_tim.data()[1])
      else
        $('#myjobmaster_ユーザ名').val('')      
  )

  $('#job_sentaku_ok').click ->
    d = oJob_modal.row('tr.selected').data()
    if d != undefined
      $('#myjobmaster_関連Job番号').val(d[0])
      $('.hint-job-refer').text(d[1])
      $('#myjobmaster_関連Job番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_関連Job番号').closest('.form-group').removeClass('has-error')

  $('#user_refer_sentaku_ok').click ->
    d = oShain_modal.row('tr.selected').data()
    if d != undefined
      $('#myjobmaster_入力社員番号').val(d[0])
      $('.hint-shain-refer').text(d[1])
      $('#myjobmaster_入力社員番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_入力社員番号').closest('.form-group').removeClass('has-error')

  $('#kaisha_sentaku_ok').click ->
    d = oKaisha_modal.row('tr.selected').data()
    if d != undefined
      $('#myjobmaster_ユーザ番号').val(d[0])
      $('#myjobmaster_ユーザ名').val(d[1])
      $('#myjobmaster_ユーザ番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_ユーザ番号').closest('.form-group').removeClass('has-error')

  $('#kaisha-table-modal tbody').on( 'dblclick', 'tr',  () ->
    $(this).addClass('selected')
    $(this).addClass('success')
    d = oKaisha_modal.row('tr.selected').data()
    if d != undefined
      $('#myjobmaster_ユーザ番号').val(d[0])
      $('#myjobmaster_ユーザ名').val(d[1])
      $('#myjobmaster_ユーザ番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_ユーザ番号').closest('.form-group').removeClass('has-error')
    $('#kaisha-search-modal').modal('hide')
  )

  $('#user_table tbody').on( 'dblclick', 'tr',  () ->
    $(this).addClass('selected')
    $(this).addClass('success')
    d = oShain_modal.row('tr.selected').data()
    if d != undefined
      $('#myjobmaster_入力社員番号').val(d[0])
      $('.hint-shain-refer').text(d[1])
      $('#myjobmaster_入力社員番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_入力社員番号').closest('.form-group').removeClass('has-error')
    $('#select_user_modal_refer').modal('hide')
  )

  $('#job_table tbody').on( 'dblclick', 'tr',  () ->
    $(this).addClass('selected')
    $(this).addClass('success')
    d = oJob_modal.row('tr.selected').data()
    if d != undefined
      $('#myjobmaster_関連Job番号').val(d[0])
      $('.hint-job-refer').text(d[1])
      $('#myjobmaster_関連Job番号').closest('.form-group').find('span.help-block').remove()
      $('#myjobmaster_関連Job番号').closest('.form-group').removeClass('has-error')
    $('#job_search_modal').modal('hide')
  )

