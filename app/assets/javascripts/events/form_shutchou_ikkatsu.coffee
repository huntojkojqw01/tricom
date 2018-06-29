jQuery ->
  if $('#event_終了').val() != ''
    $('#event3_状態コード').val(13)
    $('#event3_start').val($('#event_終了').val())

  if $('#event1_状態コード').val() == ''
    $('#event1_start').prop('disabled', true)
    $('#event1_end').prop('disabled', true)
  else
    $('#event1_start').attr('disabled', false)
    $('#event1_end').attr('disabled', false)

  if $('#event3_状態コード').val() == ''
      $('#event3_start').prop('disabled', true)
      $('#event3_end').prop('disabled', true)
  else
      $('#event3_start').attr('disabled', false)
      $('#event3_end').attr('disabled', false)

  $('.datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false

  $('#event_開始').click ()->
    $('.event_開始 .datetime').data("DateTimePicker").toggle()
  $('#event_終了').click ()->
    $('.event_終了 .datetime').data("DateTimePicker").toggle()
  $('#event1_start').click ()->
    $('.event1_start .datetime').data("DateTimePicker").toggle()
  $('#event1_end').click ()->
    $('.event1_end .datetime').data("DateTimePicker").toggle()
  $('#event3_start').click ()->
    $('.event3_start .datetime').data("DateTimePicker").toggle()
  $('#event3_end').click ()->
    $('.event3_end .datetime').data("DateTimePicker").toggle()

  $('.search-field').click ()->
    input = $(this).prev()
    switch input.attr('id')
      when 'event_場所コード' then $('#basho_search_modal').trigger('show', [input.val()])
      when 'event_JOB' then $('#job_search_modal').trigger('show', [input.val()])
  $('.search-history').click ()->
    input = $(this).prev().prev()
    switch input.attr('id')
      when 'event_場所コード' then $('#mybasho_search_modal').trigger('show', [input.val()])
      when 'event_JOB' then $('#myjob_search_modal').trigger('show', [input.val()])

  setup_tab_render_name
    input: $('#event_場所コード')
    output: $('.hint-basho-refer')
    table: $('#basho_table')
  setup_tab_render_name
    input: $('#event_JOB')
    output: $('.hint-job-refer')
    table: $('#job_table')

  $('#basho_table').on 'choose_basho', (e, selected_data)->
    if selected_data != undefined
      $('#event_場所コード').val(selected_data[0])
      $('.hint-basho-refer').text(selected_data[1])
      $('#event_場所コード').closest('.form-group').find('span.help-block').remove()
      $('#event_場所コード').closest('.form-group').removeClass('has-error')
  $('#mybasho_table').on 'choose_mybasho', (e, selected_data)->
    if selected_data != undefined
      $('#event_場所コード').val(selected_data[1])
      $('.hint-basho-refer').text(selected_data[2])
      $('#event_場所コード').closest('.form-group').find('span.help-block').remove()
      $('#event_場所コード').closest('.form-group').removeClass('has-error')

  $('#job_table').on 'choose_job', (e, selected_data)->
    if selected_data != undefined
      $('#event_JOB').val(selected_data[0])
      $('.hint-job-refer').text(selected_data[1])
      $('#event_JOB').closest('.form-group').find('span.help-block').remove()
      $('#event_JOB').closest('.form-group').removeClass('has-error')
  $('#myjob_table').on 'choose_myjob', (e, selected_data)->
    if selected_data != undefined
      $('#event_JOB').val(selected_data[1])
      $('.hint-job-refer').text(selected_data[2])
      $('#event_JOB').closest('.form-group').find('span.help-block').remove()
      $('#event_JOB').closest('.form-group').removeClass('has-error')

  # auto fill time start of event 2 when fill time end of event 1
  $(".event1_end .datetime").on 'dp.change', (e)->
    event1_end = $("#event1_end").val()
    if event1_end != ''
      $("#event_開始").val(event1_end)
  # auto fill time start of event 3 when fill time end of event 2
  $(".event_終了 .datetime").on 'dp.change', (e)->
    event_end = $("#event_終了").val()
    if event_end != ''
      $("#event3_状態コード").val(13)
      $("#event3_start").val(event_end)
      $('#event3_start').prop('disabled', false)
      $('#event3_end').prop('disabled', false)

  # when change value of joutai1
  $("#event1_状態コード").on 'change', (e)->
    event1_joutai = $("#event1_状態コード").val()
    if event1_joutai != ''
      $('#event1_start').prop('disabled', false)
      $('#event1_end').prop('disabled', false)
    else
      $('#event1_start').prop('disabled', true)
      $('#event1_end').prop('disabled',true)
      $('#event1_start').val('')
      $('#event1_end').val('')

  # when change value of joutai3
  $("#event3_状態コード").on 'change', (e)->
    event3_joutai = $("#event3_状態コード").val()
    if event3_joutai != ''
      $('#event3_start').prop('disabled', false)
      $('#event3_end').prop('disabled', false)
    else
      $('#event3_start').prop('disabled', true)
      $('#event3_end').prop('disabled', true)
      $('#event3_start').val('')
      $('#event3_end').val('')

  $('#update_shutchou').click (e) ->
    $('.form-group.has-error').each ->
      $('.help-block', $(this)).html ''
      $(this).removeClass 'has-error'
    event_start = $('#event_開始').val()
    event_end = $('#event_終了').val()
    event1_start = $('#event1_start').val()
    event1_end = $('#event1_end').val()
    event3_start = $('#event3_start').val()
    event3_end = $('#event3_end').val()
    event1_joutai = $('#event1_状態コード').val()
    event3_joutai = $('#event3_状態コード').val()
    if event_start == ''
      $input = $('#event_開始')
      $input.closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
      e.preventDefault()
    if event_end == ''
      $input = $('#event_終了')
      $input.closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
      e.preventDefault()
    if event_start != '' and event_end != '' and new Date(event_end) < new Date(event_start)
      $('#event_終了').closest('.form-group').addClass('has-error').find('.help-block').text 'は開始日以上の値にしてください。'
      e.preventDefault()
    if event1_joutai == '' and event3_joutai == ''
      $('#event1_状態コード').closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
      $('#event3_状態コード').closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
      e.preventDefault()
    if event1_joutai != ''
      if event1_start == ''
        $('#event1_start').closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
        e.preventDefault()
      if event1_end == ''
        $('#event1_end').closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
        e.preventDefault()
      if event1_start != '' and event1_end != '' and new Date(event1_end) < new Date(event1_start)
        $('#event1_end').closest('.form-group').addClass('has-error').find('.help-block').text 'は開始日以上の値にしてください。'
        e.preventDefault()
    if event3_joutai != ''
      if event3_start == ''
        $('#event3_start').closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
        e.preventDefault()
      if event3_end == ''
        $('#event3_end').closest('.form-group').addClass('has-error').find('.help-block').text 'を入力してください。'
        e.preventDefault()
      if event3_start != '' and event3_end != '' and new Date(event3_end) < new Date(event3_start)
        $('#event3_end').closest('.form-group').addClass('has-error').find('.help-block').text 'は開始日以上の値にしてください。'
        e.preventDefault()
  # nut co tac dung de tinh so gio lam dua theo 2 thoi diem da nhap
  $('#koushuusaikeisan').click (event)->
    start_time = $('#event_開始').val()
    end_time = $('#event_終了').val()
    event1_start = $('#event1_start').val()
    event1_end = $('#event1_end').val()
    event3_start = $('#event3_start').val()
    event3_end = $('#event3_end').val()

    results = time_calculate(start_time, end_time, null)
    koushuu = results.real_hours + results.fustu_zangyo + results.shinya_zangyou
    $('#event_工数').val(koushuu)

    results = time_calculate(event1_start, event1_end, null)
    koushuu = results.real_hours + results.fustu_zangyo + results.shinya_zangyou
    $('#event1_koushuu').val(koushuu)

    results = time_calculate(event3_start, event3_end, null)
    koushuu = results.real_hours + results.fustu_zangyo + results.shinya_zangyou
    $('#event3_koushuu').val(koushuu)
