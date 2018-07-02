jQuery ->
  $('#event_状態コード').change (e, selected_data)->
    if selected_data == undefined
      code = $(this).val()
      table = $('#joutai_table').DataTable()
      row = table.row (idx, data, node) ->
        if data[0] == code then true else false
      if row.length > 0
        selected_data = row.data()

    if selected_data != undefined
      # fill data to this input
      $('#event_状態コード').val(selected_data[0])
      $('.hint-joutai-refer').text(selected_data[1])
      $('#event_状態コード').closest('.form-group').find('span.help-block').remove()
      $('#event_状態コード').closest('.form-group').removeClass('has-error')

      # hide or show another input
      joutai_code = $('#event_状態コード').val()
      if KISHA_JOUTAIS.includes(joutai_code) 
        $('.event_帰社').show()
      else
          $('#event_有無').val('')
          $('.event_帰社').hide()

      if DAIKYU_JOUTAIS.includes(joutai_code)
        $.post
          url: '/events/ajax'
          data:
            id: 'get_kintais'
            joutai: joutai_code
            shain: $('#event_社員番号').val()
          success: (data)->
            console.log("OK")
          failure: ()->
            console.log("Unsuccessful")
      else
        $('#kintai_daikyu').val('')

      # neu joutaikubun = 1 hoac 5 thi disable basho, job, koutei inputs
      joutai_kubun = selected_data[3]
      tmp = joutai_kubun != '1' && joutai_kubun != '5'
      $('#event_場所コード').prop('disabled', tmp)
      $('#event_JOB').prop('disabled', tmp)
      $('#event_工程コード').prop('disabled', tmp)

  $('.event_開始 > .form-inline > .datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false

  $('#event_開始').click () ->
    $('.event_開始 > .form-inline > .datetime').data("DateTimePicker").toggle()

  $('.event_終了 > .form-inline > .datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false

  $('#event_終了').click ()->
    $('.event_終了 > .form-inline > .datetime').data("DateTimePicker").toggle()

  $('.search-field').click ()->
    input = $(this).prev()
    unless input.is(':disabled')
      switch input.attr('id')
        when 'event_状態コード' then $('#joutai_search_modal').trigger('show', [input.val()])
        when 'event_場所コード' then $('#basho_search_modal').trigger('show', [input.val()])
        when 'event_JOB' then $('#job_search_modal').trigger('show', [input.val()])
  $('.search-history').click ()->
    input = $(this).prev().prev()
    unless input.is(':disabled')
      switch input.attr('id')
        when 'event_場所コード' then $('#mybasho_search_modal').trigger('show', [input.val()])
        when 'event_JOB' then $('#myjob_search_modal').trigger('show', [input.val()])

  setup_tab_render_name
    input: $('#event_状態コード')
    output: $('.hint-joutai-refer')
    table: $('#joutai_table')
  setup_tab_render_name
    input: $('#event_場所コード')
    output: $('.hint-basho-refer')
    table: $('#basho_table')
  setup_tab_render_name
    input: $('#event_JOB')
    output: $('.hint-job-refer')
    table: $('#job_table')

  $('#joutai_table').on 'choose_joutai', (e, selected_data)->
    if selected_data != undefined
      $('#event_状態コード').trigger('change', [selected_data])

  $('#daikyu_table').on 'choose_daikyu', (e, selected_data)->
    if selected_data != undefined
      $('#kintai_daikyu').val(selected_data[0])

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

  # nut co tac dung goi ajax de tinh so gio lam dua theo 2 thoi diem da nhap
  $('#koushuusaikeisan').click (event)->
    start_time = $('#event_開始').val()
    end_time = $('#event_終了').val()
    if start_time != '' && end_time != ''
      $.post
        url: '/events/ajax'
        data:
          id: 'get_kousuu'
          start_time: start_time
          end_time: end_time
        success: (data)->
          if data.kousuu != ''
            $('#event_工数').val(data.kousuu)
        failure: ()->
          console.log("save-kinmu-type field")
