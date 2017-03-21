jQuery ->
  kousu = []
  countup = 0
  until countup > 1000
    kousu.push(countup)
    countup += 0.25

  $('#koushuu').click (event) ->
    start_time = $('#event_開始').val()
    end_time = $('#event_終了').val()
    diff = moment(end_time,'YYYY/MM/DD HH:mm').diff(moment(start_time,'YYYY/MM/DD HH:mm'),'hours', true)

#    kyukei = $('#kyukei').val()
#    if(!isNaN(kyukei) && kyukei.length != 0) then diff -= parseFloat(kyukei)

    for num in kousu
      if num > diff && num > 0
        $('#event_工数').val(num-0.25)
        break

#  保留中 →
  $('.add-row').click () ->
    val = []
    val.push($('#basho-code').val())
    val.push($('#basho-name').val())

    jQuery.ajax({
      url: '/events/event_basho_add',
      data: {id: 'event_basho_add', data: val},
      type: "POST",
#    // processData: false,
#    // contentType: 'application/json',
      success: (data) ->
        oBashoTable.row.add(val).draw(false)
      ,failure: () ->
        console.log("場所 追加 失敗")
    })

#  $('#save_kinmu_type').click () ->
  $('#shainmaster_勤務タイプ').on('change', () ->
#    val = $('#shainmaster_勤務タイプ').val()
    val = $(this).val()
    jQuery.ajax({
      url: '/events/ajax',
      data: {id: 'save_kinmu_type', data: val},
      type: "POST",
      success: (data) ->
#        swal('勤務タイプ保存！')
      failure: () ->
        console.log("save-kinmu-type field")
    }))

  $('#shainmaster_所在コード').on('change', () ->
    val = $(this).val()
    jQuery.ajax({
      url: '/events/ajax',
      data: {id: 'change_shozai', data: val},
      type: "POST",
      success: (data) ->
        #location.reload()
      failure: () ->
        console.log("change_shozai field")
    }))

  $('#timeline_所在コード').on('change', () ->
    val = $(this).val()
    jQuery.ajax({
      url: '/events/ajax',
      data: {id: 'change_shozai_timeline', data: val},
      type: "POST",
      success: (data) ->
        $('.fc-resource-area tr[data-resource-id="'+data.resourceID+'"] td:nth-child(3)').css('color',data.color).css('background-color',data.bgColor);
        $('.fc-resource-area tr[data-resource-id="'+data.resourceID+'"] td:nth-child(3)').text(data.joutai);
      failure: () ->
        console.log("change_shozai field")
    }))

  $('#basho-new').click () ->
    $('#mybasho-new-modal').modal('show')

  $('#kaisha-new').click () ->
    $('#kaisha-new-modal').modal('show')

  $('.refer-kaisha').click () ->
    $('#kaisha-search-modal').modal('show')

  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    calendarWeeks: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
#    defaultDate: '2016/03/14 09:00'
  })

  $('.search-field').click( () ->
    element1 = $('.search-group').find('#event_状態コード')
    element2 = $('.search-group').find('#event_場所コード')
    element3 = $('.search-group').find('#event_JOB')
    element4 = $('.search-group').find('#event_工程コード')
    element5 = $('.search-group').find('#mybashomaster_会社コード')

    if $(this).prev().is(element1)
      $('#joutai_search_modal').modal('show')

    if $(this).prev().is(element2)
      $('#basho_search_modal').modal('show')

    if $(this).prev().is(element3)
      $('#job_search_modal').modal('show')

    if $(this).prev().is(element4)
      $('#koutei_search_modal').modal('show')

    if $(this).prev().is(element5)
      $('#kaisha-search-modal').modal('show')
  )

  $('.search-plus').click( () ->
    $('#mybasho-new-modal').modal('show')

    element = $('.search-group').find('#mybashomaster_会社コード')
    if $(this).prev().prev().is(element)
      $('#kaisha-new-modal').modal('show')
      $('#kaisha-new-modal #kaishamaster_会社コード').val('');
      $('#kaisha-new-modal #kaishamaster_会社名').val('');
      $('#kaisha-new-modal #kaishamaster_備考').val('');
  )

  $('.search-history').click( () ->
    $('#mybasho_search_modal').modal('show')
  )
  $('.search-history-job').click( () ->
    $('#myjob_search_modal').modal('show')
  )

  $('#basho-new-ok').click( () ->
    basho_code = $('#mybashomaster_場所コード').val()
    if basho_code
      $('#event_場所コード').val(basho_code)
      $('.hint-basho-refer').text($('#mybashomaster_場所名').val())
)