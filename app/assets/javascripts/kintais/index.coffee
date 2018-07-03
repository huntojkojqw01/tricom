jQuery ->
  # Code cho khu vuc 3 nut tren top:
  $('#modal_print_kintai, #export_pdf').click ->
    window.open('/kintais/pdf_show.pdf?locale=ja&search=' + $("#search").val())
  $('#import_kintai').click ->
    $('#import_kintais_modal').modal('show')
  $('#export_kintai').click ->
    window.open('/kintais/export_csv.csv?locale=ja')

  # Code cho khu vuc chon nam thang:
  now = new Date()
  current = new Date(now.getFullYear(), now.getMonth()+1, 1)
  $('.date-search').datetimepicker
    format: 'YYYY/MM'
    viewMode: 'months'
    keyBinds: false
    focusOnShow: false
    maxDate: moment(current).format('YYYY/MM/DD')
  .on 'dp.show', ->
    $('.date-search').data("DateTimePicker").viewMode("months")

  $('#search').click () ->
    $('.date-search').data("DateTimePicker").viewMode("months").toggle()

  $('.best_in_place').best_in_place()
  # Call ajax de lay du lieu cac tong o footer:
  summary = ()->
    gesshozan = $('.input-number').text()
    if gesshozan == ''
      gesshozan = 0.0
    else
      gesshozan = parseFloat(gesshozan)

    yuukyu = $('.sum8').text()

    if yuukyu == ''
      yuukyu = 0
    else
      yuukyu = parseFloat(yuukyu)

    sum = gesshozan - yuukyu
    sum = 0.0 if sum < 0
    $('.sum-yuukyu').text(sum.toFixed(1))
  $('.summary').trigger('click')

  # Khi cap nhat mot kintai, co the se phai cap nhat cac kintai lien quan vi du nhu lam bu:
  set_value_for_related_kintai = (result)->
    if result.current_kintai.id != ''
      $('#best_in_place_kintai_'+result.current_kintai.id+'_状態1').text(result.current_kintai.joutaimei || '')
      $('#best_in_place_kintai_'+result.current_kintai.id+'_状態1').val(result.current_kintai.joutai)
      $('#bikou_'+result.current_kintai.id).text(result.current_kintai.bikou || '')

    if result.related_kintai.id != ''
      $('#best_in_place_kintai_'+result.related_kintai.id+'_状態1').text(result.related_kintai.joutaimei || '')
      $('#best_in_place_kintai_'+result.related_kintai.id+'_状態1').val(result.related_kintai.joutai)
      $('#bikou_'+result.related_kintai.id).text(result.related_kintai.bikou || '')

    if result.related_kintai2.id != ''
      $('#best_in_place_kintai_'+result.related_kintai2.id+'_状態1').text(result.related_kintai2.joutaimei || '')
      $('#best_in_place_kintai_'+result.related_kintai2.id+'_状態1').val(result.related_kintai2.joutai)
      $('#bikou_'+result.related_kintai2.id).text(result.related_kintai2.bikou || '')

  joutai_index = ''
  id_kintai = ''
  $('.hoshukeitai-edit').on 'ajax:success', (event, data, status, xhr) ->
    joutai = $(this).attr("data-bip-value")
    id_kintai = $(this).attr('id').split('_')[4]
    joutai_index = joutai

    if joutai == '105' || joutai == '109' || joutai == '113'
      $.post
        url: '/kintais/ajax'
        data:
          id: 'get_kintais'
          joutai: joutai
        success: (data) ->
          console.log("OK")
        failure: () ->
    else
      set_value_for_related_kintai($.parseJSON(data))

  $('#daikyu_table').on 'choose_daikyu', (e, selected_data)->
    if selected_data != undefined
      d = selected_data
      bikou = ''
      if d != undefined
        if joutai_index == '105'
          bikou = d[0] + 'の振休'
        else if joutai_index == '109'
          bikou = d[0] + 'の午前振休'
        else if joutai_index == '113'
          bikou = d[0] + 'の午後振休'
        $.ajax
          type: 'PUT'
          url:  '/kintais/'+id_kintai
          data:
            kintai:
              状態1: joutai_index
              代休相手日付: d[0]
              備考: bikou
          dataType: "JSON"
          success: (data) ->
            set_value_for_related_kintai(data)

  $('.kintai-item').on 'keydown', '.best_in_place', (e)->
    keyCode = e.keyCode || e.which
    if keyCode == 9 || keyCode == 13
      e.preventDefault()
      $(this).parent().next('.kintai-item').trigger('click')
      if $(this).parent().next('.kintai-item').length == 0
        $(this).parent().parent().next().find('.kintai-item').first().trigger('click')

  $('.kintai-item').on 'change', ()->
    if $(this).next('.kintai-item').length == 0
      $(this).parent().next().find('.kintai-item').first().trigger('click')
    $('.summary').trigger('click')

  $('.time-start').datetimepicker
    format: 'HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false
  .on "dp.hide", (e)->
    idRow = $(this).find('.input-time-start').attr('id')
    idKintai = idRow.substring(13,idRow.length)
    $("#shukkinjikoku_picker_"+idKintai).hide()
    $("#shukkinjikoku_text_"+idKintai).show()
    $("#shukkinjikoku_text_"+idKintai).text($("#shukkinjikoku"+idKintai).val())
    update_kintai(idKintai)

  $('.time-end').datetimepicker
    format: 'HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false
  .on "dp.hide", (e)->
    idRow = $(this).find('.input-time-end').attr('id')
    idKintai = idRow.substring(12,idRow.length)
    $("#taishajikoku_picker_"+idKintai).hide()
    $("#taishajikoku_text_"+idKintai).show()
    $("#taishajikoku_text_"+idKintai).text($("#taishajikoku"+idKintai).val())
    update_kintai(idKintai)

  $('.input-time-start').click ->
    $(this).closest('.time-start').data("DateTimePicker").toggle()
  $('.input-time-end').click ->
    $(this).closest('.time-end').data("DateTimePicker").toggle()

  $('.best_in_place[data-bip-attribute="勤務タイプ"]').on 'change', ()->
    kinmutype = $(this).text()
    idKintai = $(this).attr('id')
    date = $('#date'+idKintai).text()
    $.post
      url: '/kintais/ajax'
      data:
        id: 'update_kinmutype'
        kinmutype: kinmutype
        idKintai: idKintai
        date: date
      success: (data) ->
        $('#shukkinjikoku'+idKintai).val(data.starttime)
        $('#taishajikoku'+idKintai).val(data.endtime)
        $("#shukkinjikoku_text_"+idKintai).text(data.starttime)
        $("#taishajikoku_text_"+idKintai).text(data.endtime)
        $('#best_in_place_kintai_'+idKintai+"_実労働時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_遅刻時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_普通残業時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_深夜残業時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_普通保守時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_深夜保守時間").text('')
      failure: () ->
        console.log("update_kinmutype field")

  $('.summary').click ()->
    $.getJSON '/kintais/search', (data)->
      $('.sum1').text(data.summary.sum1)
      $('.sum2').text(data.summary.sum2)
      $('.sum3').text(data.summary.sum3)
      $('.sum4').text(data.summary.sum4)
      $('.sum5').text(data.summary.sum5)
      $('.sum6').text(data.summary.sum6)
      $('.sum7').text(data.summary.sum7)
      $('.sum8').text(data.summary.sum8)
      summary()

  $('#kintai-table').on 'click', 'td', ()->
    id_column = $(this).attr("id")
    if id_column != undefined
      $('td').filter ()->
        if $(this).attr("id")!= undefined && $(this).attr("id") != id_column
          idColumn = $(this).attr("id")
          if idColumn.substring(0,21) == "shukkinjikoku_picker_" && $(this).css('display') != 'none'
            $(this).css('display', 'none')
            $("#shukkinjikoku_text_"+idColumn.substring(21,idColumn.length)).css("display","")
          else if idColumn.substring(0,20) == "taishajikoku_picker_" && $(this).css('display') != 'none'
            $(this).css('display', 'none')
            $("#taishajikoku_text_"+idColumn.substring(20,idColumn.length)).css("display","")
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

  # Ham xu li cac gia tri start va end duoc nhap, tuy truong hop co the update 1 phan, hay update toan bo:
  update_kintai = (idKintai)->
    date = $('#date'+idKintai).text()
    start_input = $("#shukkinjikoku"+idKintai).val()
    end_input = $("#taishajikoku"+idKintai).val()
    if start_input != ''
      start_time = date + ' ' + start_input
      if end_input != ''
        if end_input >= '00:00' && end_input <= '07:00'
          nextDay = moment(date).add('days',1)
          date = moment(nextDay).format("YYYY/MM/DD")
        end_time = date + ' ' + end_input
        calculater(start_time,end_time,idKintai)
      else
        $.post
          url: '/kintais/ajax'
          data:
            id: 'update_starttime'
            timeStart: start_time
            idKintai: idKintai
          success: (data) ->
            console.log("update_starttime success")
          failure: () ->
            console.log("update_starttime failed")
        return
    else
      if end_input != ''
        if end_input >= '00:00' && end_input <= '07:00'
          nextDay = moment(date).add('days',1)
          date = moment(nextDay).format("YYYY/MM/DD")
        end_time = date + ' ' + end_input
        $.post
          url: '/kintais/ajax'
          data:
            id: 'update_endtime'
            timeEnd: end_time
            idKintai: idKintai
          success: (data) ->
          console.log("update_endtime success")
          failure: () ->
            console.log("update_endtime failed")
      else
        calculater(start_time,end_time,idKintai)

  calculater = (start_time, end_time, idKintai) ->
    kinmutype = $('#kinmutype'+idKintai).text()
    results = time_calculate(start_time, end_time, kinmutype)
    $('#best_in_place_kintai_'+idKintai+"_実労働時間").text(results.real_hours + results.fustu_zangyo + results.shinya_zangyou || '')
    $('#best_in_place_kintai_'+idKintai+"_遅刻時間").text(results.chikoku_soutai || '')
    $('#best_in_place_kintai_'+idKintai+"_普通残業時間").text(results.fustu_zangyo || '')
    $('#best_in_place_kintai_'+idKintai+"_深夜残業時間").text(results.shinya_zangyou || '')
    $('#best_in_place_kintai_'+idKintai+"_深夜保守時間").text(results.shinya_kyukei || '')

    $.post
      url: '/kintais/ajax'
      data:
        id: 'update_time'
        timeStart: start_time
        timeEnd: end_time
        idKintai: idKintai
        real_hours: results.real_hours || ''
        fustu_zangyo: results.fustu_zangyo || ''
        shinya_zangyou: results.shinya_zangyou || ''
        yoru_kyukei: results.yoru_kyukei || ''
        shinya_kyukei: results.shinya_kyukei || ''
        chikoku_soutai: results.chikoku_soutai || ''
      success: (data) ->
        console.log("update_time success")
      failure: () ->
        console.log("update_time failed")

  # An hien bang kinmu_refer:
  $('#kinmu_toggle').click ->
    $('#kinmu_refer').toggle()