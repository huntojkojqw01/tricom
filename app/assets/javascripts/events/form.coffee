jQuery ->
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
    switch input.attr('id')
      when 'event_状態コード' then $('#joutai_search_modal').trigger('show', [input.val()])
      when 'event_場所コード' then $('#basho_search_modal').trigger('show', [input.val()])
      when 'event_JOB' then $('#job_search_modal').trigger('show', [input.val()])
  $('.search-history').click ()->
    input = $(this).prev().prev()
    switch input.attr('id')
      when 'event_場所コード' then $('#mybasho_search_modal').trigger('show', [input.val()])
      when 'event_JOB' then $('#myjob_search_modal').trigger('show', [input.val()])

  $('#joutai_search_modal').on 'choose_joutai', (e, selected_data)->
    if selected_data != undefined
      # fill data to this input
      $('#event_状態コード').val(selected_data[0])
      $('hint-joutai-refer').val(selected_data[1])
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

      oJoutaiTable = $('#joutai_table').DataTable()
      row_can_tim = oJoutaiTable.row (idx, data, node)->
        if data[0] == joutai_code then true else false
      if row_can_tim.length > 0
        joutai_kubun = row_can_tim.data()[3]
      else
        joutai_kubun = ''
      if joutai_kubun == '1' or joutai_kubun == '5'
        $('#event_場所コード').prop( "disabled", false )
        $('#event_JOB').prop( "disabled", false )
        $('#event_工程コード').prop( "disabled", false )
      else
        $('#event_場所コード').prop( "disabled", true )
        $('#event_JOB').prop( "disabled", true )
        $('#event_工程コード').prop( "disabled", true )

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
