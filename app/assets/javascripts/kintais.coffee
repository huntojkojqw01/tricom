# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.best_in_place').best_in_place()

  $('.date-search').datetimepicker({
    format: 'YYYY/MM',
    viewMode: 'months',
    keyBinds: false,
    focusOnShow: false
  }).on('dp.show', () ->
    $('.date-search').data("DateTimePicker").viewMode("months")
  );

  $('.date-edit').datetimepicker({
    format: 'YYYY/MM/DD',
#   //inline: true,
#   //widgetParent: 'container-fluid',
    showTodayButton: true,
#   //showClear: true,
#   //,daysOfWeekDisabled:[0,6]
#   //calendarWeeks: true,
    keyBinds: false,
    focusOnShow: false
  })

  $('#search').click () ->
    $('.date-search').data("DateTimePicker").viewMode("months").toggle();

  $('#kintai_出勤時刻').click () ->
    $('.datetime').data("DateTimePicker").toggle();

  $('#kintai_退社時刻').click () ->
    $('.kintai_退社時刻 .datetime').data("DateTimePicker").toggle();

  status = 0
  $(document).on 'click', '.refer-joutai', (event) ->
    $('#joutai_search_modal').modal('show')
#    status = 1
    event.preventDefault()

#  $(document).on 'click', '.status2', (event) ->
#    $('#joutai_search_modal').modal('show')
#    status = 2
#    event.preventDefault()
#
#  $(document).on 'click', '.status3', (event) ->
#    $('#joutai_search_modal').modal('show')
#    status = 3
#    event.preventDefault()

  oJoutai_search_modal = $('#joutai_table').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }})

  joutaikubun = ''
  $('#joutai_table tbody').on 'click', 'tr', (event) ->
    d = oJoutai_search_modal.row(this).data()
    $('#kintai_状態1').val(d[0])
    $('.joutai-code-hint').text(d[1])
    joutaikubun = d[3]
    if d[0] == '30' #有給
      $('#kintai_出勤時刻_4i').val('00')
      $('#kintai_出勤時刻_5i').val('00')
      $('#kintai_退社時刻_4i').val('00')
      $('#kintai_退社時刻_5i').val('00')
    if d[1] == '振休'
      $('#joutai_search_modal').modal('hide')
      $('#daikyu_search_modal').modal('show')

    #    switch status
#      when 1 then $('.status1-code').val(d[0])
#      when 2 then $('.status2-code').val(d[0])
#      when 3 then $('.status3-code').val(d[0])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oJoutai_search_modal.$('tr.selected').removeClass('selected')
      oJoutai_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

#  $('.kintai-sum').click () ->
#    jQuery.ajax({
#      url: '/kintais/summary_kintai',
#      data: {id: 'kintaisum'},
#      type: "POST",
#      success: (data) ->
#        $('.sum1').text(data.sum1)
#        $('.sum2').text(data.sum2)
#        $('.sum3').text(data.sum3)
#        $('.sum4').text(data.sum4)
#        $('.sum5').text(data.sum5)
#        $('.sum6').text(data.sum6)
#      failure: () ->
#    })

  $.getJSON('/kintais/search', (data) ->
    $('.sum1').text(data.summary.sum1)
    $('.sum2').text(data.summary.sum2)
    $('.sum3').text(data.summary.sum3)
    $('.sum4').text(data.summary.sum4)
    $('.sum5').text(data.summary.sum5)
    $('.sum6').text(data.summary.sum6)
    $('.sum7').text(data.summary.sum7)
    $('.sum8').text(data.summary.sum8)
    #$('.input-number').val(data.summary.sum9)
    summary()
  )

  $('#finish-input').click () ->
    date = $('#kintai_日付').val()
    jQuery.ajax({
      url: '/kintais/finish_input',
      data: {id: 'finish_input', date: date, checked: $(this).prop('checked')},
      type: "POST",
      success: (data) ->
        $('.finish-message').text(data.message)
      failure: () ->
    })

  $(document).ready () ->
    $('.date-search').datetimepicker("show")
    $('.date-search').datetimepicker("hide")
#    fill_time()


  $('.kintai-item').on 'keydown', '.best_in_place', (e) ->
    keyCode = e.keyCode || e.which
    if keyCode == 9 || keyCode == 13
      e.preventDefault()
      $(this).parent().next('.kintai-item').trigger('click')
      if $(this).parent().next('.kintai-item').length == 0
        $(this).parent().parent().next().find('.kintai-item').first().trigger('click')

  $('.kintai-item').on('change',() ->
    if $(this).next('.kintai-item').length == 0
      $(this).parent().next().find('.kintai-item').first().trigger('click')
  )

  $('#kintai_勤務タイプ').on('change',() ->
    fill_time2()
  )

  fill_time2 = () ->
    selected_val = $('#kintai_勤務タイプ').val()
    start_time = moment().format('YYYY/MM/DD')
    end_time = moment().format('YYYY/MM/DD')
    real_time = 8
    switch (selected_val)
      when '001'
        start_time += ' 07:00'
        end_time += ' 16:00'
      when '002'
        start_time += ' 07:30'
        end_time += ' 16:30'
      when '003'
        start_time += ' 08:00'
        end_time += ' 17:00'
      when '004'
        start_time += ' 08:30'
        end_time += ' 17:30'
      when '005'
        start_time += ' 09:00'
        end_time += ' 18:00'
      when '006'
        start_time += ' 09:30'
        end_time += ' 18:30'
      when '007'
        start_time += ' 10:00'
        end_time += ' 19:00'
      when '008'
        start_time += ' 10:30'
        end_time += ' 19:30'
      when '009'
        start_time += ' 11:00'
        end_time += ' 20:00'
      else
        real_time = 0
    $('#kintai_出勤時刻').val(start_time)
    $('#kintai_退社時刻').val(end_time)

    $('#kintai_遅刻時間').val(0)
    $('#kintai_普通保守時間').val(0)
    $('#kintai_深夜残業時間').val(0)
    $('#kintai_深夜保守時間').val(0)
    $('#kintai_実労働時間').val(real_time)
    $('#kintai_普通残業時間').val(0)


  oDaikyuTable = $('.daikyutable').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
  })

  $('.daikyutable tbody').on 'click', 'tr', (event) ->
    d = oDaikyuTable.row(this).data()
    $('#kintai_代休相手日付').val(d[0])
    $('#kintai_代休取得区分').val('1')
    $('#kintai_備考').val(d[0] + 'の振休')

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oDaikyuTable.$('tr.selected').removeClass('selected')
      oDaikyuTable.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  kousu = []
  countup = 0
  until countup > 1000
    kousu.push(countup)
    countup += 0.5

  $('#time-cal').on 'click', (event) ->
    start_time = $('#kintai_出勤時刻').val()
    end_time = $('#kintai_退社時刻').val()

    start_time_date = start_time.substring(0,10)
    end_time_date = end_time.substring(0,10)

    read_hours = 0
    fustu_zangyo = 0
    shinya_zangyou = 0

    shinya_diff = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time_date + ' 22:00', 'YYYY/MM/DD HH:mm'),'hours', true)
    if shinya_diff > 0
      for num in kousu
        if num > shinya_diff && num > 0
          shinya_zangyou = num - 0.5
          break

    fustu_zangyou_diff = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time_date + ' 19:00', 'YYYY/MM/DD HH:mm'),'hours', true)
    if fustu_zangyou_diff > 0
      for num in kousu
        if num > fustu_zangyou_diff && num > 0
          fustu_zangyo = num - 0.5
          break
    if fustu_zangyo > 3 then fustu_zangyo = 3

    fustu_end = end_time
    fustu_start = start_time
    if moment(end_time, 'YYYY/MM/DD HH:mm') > moment(start_time_date + ' 18:00', 'YYYY/MM/DD HH:mm') then fustu_end = start_time_date + ' 18:00'
    if moment(start_time, 'YYYY/MM/DD HH:mm') > moment(start_time_date + ' 12:00', 'YYYY/MM/DD HH:mm') && moment(start_time, 'YYYY/MM/DD HH:mm') < moment(start_time_date + ' 13:00', 'YYYY/MM/DD HH:mm') then fustu_start = start_time_date + ' 13:00'

    fustu_diff = moment(fustu_end, 'YYYY/MM/DD HH:mm').diff(moment(fustu_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if moment(start_time_date + ' 12:00', 'YYYY/MM/DD HH:mm') > moment(start_time, 'YYYY/MM/DD HH:mm') then fustu_diff -= 1

    if fustu_diff > 0
      for num in kousu
        if num > fustu_diff && num > 0
          read_hours = num - 0.5
          break

    read_hours += fustu_zangyo + shinya_zangyou
    if joutaikubun == '2'
      $('#kintai_遅刻時間').val('0')
    $('#kintai_実労働時間').val(read_hours)
    $('#kintai_普通残業時間').val(fustu_zangyo)
    $('#kintai_深夜残業時間').val(shinya_zangyou)
    $('#kintai_深夜保守時間').val()

  $('.datetime').datetimepicker({
    format: 'YYYY/MM/DD HH:mm',
#    format: 'LT',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
#    calendarWeeks: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
#    defaultDate: '2016/03/14 09:00'
  })

  $('#export_kintai').click( () ->
    location.href='/kintais/export_csv.csv?locale=ja';
  )

  $('#export_pdf').click( () ->
    window.open('/kintais/pdf_show.pdf?locale=ja&search='+$("#search").val());
  )
  $('.time').datetimepicker({
    format: 'HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
  }).on("dp.hide", (e) ->
    idRow = $(this).find('.input-time').attr('id')
    idKintai = idRow.substring(12,idRow.length)
    $("#taishajikoku_picker_"+idKintai).css("display","none")
    $("#taishajikoku_text_"+idKintai).css("display","")
    time = $("#taishajikoku"+idKintai).val()
    $("#taishajikoku_text_"+idKintai).text(time)
  )

  $('.input-time').click( () ->
    $(this).closest('.time').data("DateTimePicker").toggle();
  );

  $('.time').on('dp.change', (e) ->
    idRow = $(this).find('.input-time').attr('id')
    idKintai = idRow.substring(12,idRow.length)
    date = $('#date'+idKintai).text()
    time = $(this).find('.input-time').val()
    #alert(date+" "+ time)

    jQuery.ajax({
      url: '/kintais/ajax',
      data: {id: 'update_endtime', timeEnd: date+" "+ time, idKintai: idKintai},
      type: "POST",
      success: (data) ->
#       console.log("update_endtime success")
      failure: () ->
        console.log("update_endtime field")
    })
  )

  $('.timestart').datetimepicker({
    format: 'HH:mm',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    toolbarPlacement: 'top',
    keyBinds: false,
    focusOnShow: false
  }).on("dp.hide", (e) ->
    idRow = $(this).find('.input-time-start').attr('id')
    idKintai = idRow.substring(13,idRow.length)
    $("#shukkinjikoku_picker_"+idKintai).css("display","none")
    $("#shukkinjikoku_text_"+idKintai).css("display","")
    time = $("#shukkinjikoku"+idKintai).val()
    $("#shukkinjikoku_text_"+idKintai).text(time)
  )

  $('.input-time-start').click( () ->
    $(this).closest('.timestart').data("DateTimePicker").toggle();
  );

  $('.timestart').on('dp.change', (e) ->
    idRow = $(this).find('.input-time-start').attr('id')
    idKintai = idRow.substring(13,idRow.length)
    date = $('#date'+idKintai).text()
    time = $(this).find('.input-time-start').val()
    #alert(date+" "+ time)

    jQuery.ajax({
      url: '/kintais/ajax',
      data: {id: 'update_starttime', timeStart: date+" "+ time, idKintai: idKintai},
      type: "POST",
      success: (data) ->
#       console.log("update_endtime success")
      failure: () ->
        console.log("update_endtime field")
    })
  )

  $('.best_in_place[data-bip-attribute="勤務タイプ"]').on('change', () ->
    kinmutype = $(this).text()
    idKintai = $(this).attr('id')
    date = $('#date'+idKintai).text()
    jQuery.ajax({
      url: '/kintais/ajax',
      data: {id: 'update_kinmutype', kinmutype: kinmutype, idKintai: idKintai, date: date},
      type: "POST",
      success: (data) ->
        $('#shukkinjikoku'+idKintai).val(data.starttime)
        $('#taishajikoku'+idKintai).val(data.endtime)
        $("#shukkinjikoku_text_"+idKintai).text(data.starttime)
        $("#taishajikoku_text_"+idKintai).text(data.endtime)
      failure: () ->
        console.log("update_kinmutype field")
    })
  )

  $('.summary').click( () ->
    $.getJSON('/kintais/search', (data) ->
      $('.sum1').text(data.summary.sum1)
      $('.sum2').text(data.summary.sum2)
      $('.sum3').text(data.summary.sum3)
      $('.sum4').text(data.summary.sum4)
      $('.sum5').text(data.summary.sum5)
      $('.sum6').text(data.summary.sum6)
      $('.sum7').text(data.summary.sum7)
      $('.sum8').text(data.summary.sum8)

    )
  );

  $('.input-number').on('change', () ->
    summary()
  )

  $('input').keydown( (e) ->
    if e.keyCode == 13
      if $('.input-number').is( ":focus" )
        e.preventDefault();
        $('.input-number').blur();
  );

  summary = () ->
    gesshozan = $('.input-number').val()
    if gesshozan == ''
      gesshozan = 0
    else
      gesshozan = parseFloat(gesshozan)

    yuukyu = $('.sum8').text()

    if yuukyu == ''
      yuukyu = 0
    else
      yuukyu = parseFloat(yuukyu)

    sum = gesshozan - yuukyu
    $('.sum-yuukyu').text(sum)

  $('#kintai-table').on('click', 'td', () ->
    id_column = $(this).attr("id")
    $('td').filter( () ->
      if $(this).attr("id")!= undefined && $(this).attr("id") != id_column
        idColumn = $(this).attr("id")
        if idColumn.substring(0,21) == "shukkinjikoku_picker_" && $(this).css('display') != 'none'
          $(this).css('display', 'none')
          $("#shukkinjikoku_text_"+idColumn.substring(21,idColumn.length)).css("display","")
        else if idColumn.substring(0,20) == "taishajikoku_picker_" && $(this).css('display') != 'none'
          $(this).css('display', 'none')
          $("#taishajikoku_text_"+idColumn.substring(20,idColumn.length)).css("display","")
    );
    if id_column.substring(0,13) == "shukkinjikoku"
      id_column = $(this).attr("id")
      if id_column.substring(0,21) != "shukkinjikoku_picker_"
        id = id_column.substring(19,id_column.length)
        $("#shukkinjikoku_picker_"+id).css("display","")
        $("#shukkinjikoku_text_"+id).css("display","none")

    else if id_column.substring(0,12) == "taishajikoku"
      id_column = $(this).attr("id")
      if id_column.substring(0,20) != "taishajikoku_picker_"
        id = id_column.substring(18,id_column.length)
        $("#taishajikoku_picker_"+id).css("display","")
        $("#taishajikoku_text_"+id).css("display","none")
  );
