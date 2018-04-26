# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.best_in_place').best_in_place()
  now = new Date();
  current = new Date(now.getFullYear(), now.getMonth()+1, 1);

  $('.date-search').datetimepicker({
    format: 'YYYY/MM',
    viewMode: 'months',
    keyBinds: false,
    focusOnShow: false,
    maxDate: moment(current).format('YYYY/MM/DD'),
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

  $('#kinmu_refer').hide()
  $('.kinmu-hide').hide()
  $(document).on 'click', '.kinmu-hide', (event) ->
    $('#kinmu_refer').hide()
    $('.kinmu-hide').hide()
    $('.kinmu-show').show()
    event.preventDefault()

  $(document).on 'click', '.kinmu-show', (event) ->
    $('#kinmu_refer').show()
    $('.kinmu-show').hide()
    $('.kinmu-hide').show()
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
  fukyu_code = ''
  fukyu_name = ''
  $('#joutai_table tbody').on 'click', 'tr', (event) ->
    d = oJoutai_search_modal.row(this).data()
    if d[0] == '105' || d[0] == '109' || d[0] == '113' #振替勤務, 午前振出, 午後振出
      fukyu_code = d[0]
      fukyu_name = d[1]
      $('#joutai_search_modal').modal('hide')
      jQuery.ajax({
        url: '/kintais/ajax',
        data: {id: 'get_kintais', joutai: d[0]},
        type: "POST",
        success: (data) ->
          console.log("OK");
        failure: () ->
      })
    else
      $('#kintai_状態1').val(d[0])
      $('.joutai-code-hint').text(d[1])
      joutaikubun = d[3]
      if d[0] == '30' #有給
        $('#kintai_出勤時刻_4i').val('00')
        $('#kintai_出勤時刻_5i').val('00')
        $('#kintai_退社時刻_4i').val('00')
        $('#kintai_退社時刻_5i').val('00')


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


  joutai_index = ''
  id_kintai = ''
  select_daikyu = 'false'
  $('.hoshukeitai-edit').on 'ajax:success', (event, data, status, xhr) ->
    # newValue = $('.hoshukeitai-edit').html # could also use .attr() here

  # $('.best_in_place[data-bip-attribute="状態1"]').on('change', (e) ->
    joutai = $(this).attr("data-bip-value")
    id_kintai = $(this).attr('id').split('_')[4]
    joutai_index = joutai

    if joutai == '105' || joutai == '109' || joutai == '113'
      jQuery.ajax({
          url: '/kintais/ajax',
          data: {id: 'get_kintais', joutai: joutai},
          type: "POST",
          success: (data) ->
            console.log("OK");
          failure: () ->
        })
    else
      result = $.parseJSON(data);

      if result.current_kintai.joutaimei == null
        current_joutaimei = ''
      else
        current_joutaimei = result.current_kintai.joutaimei

      if result.current_kintai.bikou == null
        current_bikou = ''
      else
        current_bikou = result.current_kintai.bikou

      if result.related_kintai.joutaimei == null
        related_joutaimei = ''
      else
        related_joutaimei = result.related_kintai.joutaimei

      if result.related_kintai.bikou == null
        related_bikou = ''
      else
        related_bikou = result.related_kintai.bikou

      if result.related_kintai2.joutaimei == null
        related_joutaimei2 = ''
      else
        related_joutaimei2 = result.related_kintai2.joutaimei

      if result.related_kintai2.bikou == null
        related_bikou2 = ''
      else
        related_bikou2 = result.related_kintai2.bikou

      if result.current_kintai.id != ''
        $('#best_in_place_kintai_'+result.current_kintai.id+'_状態1').text(current_joutaimei)
        $('#best_in_place_kintai_'+result.current_kintai.id+'_状態1').val(result.current_kintai.joutai)
        $('#bikou_'+result.current_kintai.id).text(current_bikou)

      if result.related_kintai.id != ''
        $('#best_in_place_kintai_'+result.related_kintai.id+'_状態1').text(related_joutaimei)
        $('#best_in_place_kintai_'+result.related_kintai.id+'_状態1').val(result.related_kintai.joutai)
        $('#bikou_'+result.related_kintai.id).text(related_bikou)
      if result.related_kintai2.id != ''
        $('#best_in_place_kintai_'+result.related_kintai2.id+'_状態1').text(related_joutaimei2)
        $('#best_in_place_kintai_'+result.related_kintai2.id+'_状態1').val(result.related_kintai2.joutai)
        $('#bikou_'+result.related_kintai2.id).text(related_bikou2)
      # alert(result.current_kintai.id+"\n"+result.current_kintai.joutai+"\n"+result.current_kintai.bikou+"\n"+result.related_kintai.id)
      # alert(result.current_kintai.id+"\n"+result.current_kintai.joutai+"\n"+result.current_kintai.bikou+"\n"+result.related_kintai.id+"\n"+result.related_kintai.joutai+"\n"+result.related_kintai.bikou+"\n")
      # location.reload()


  $('#daikyu_index_sentaku_ok').click () ->
    d = oDaikyuTable.row('tr.selected').data()
    bikou = ''
    if d != undefined
      select_daikyu = 'true'
      if joutai_index == '105'
        bikou = d[0] + 'の振休'
      else if joutai_index == '109'
        bikou = d[0] + 'の午前振休'
      else if joutai_index == '113'
        bikou = d[0] + 'の午後振休'
      $.ajax({
        type: 'PUT',
        url:  '/kintais/'+id_kintai,
        data: {kintai: {状態1: joutai_index,代休相手日付: d[0],備考: bikou}},
        dataType: "JSON",
        success: (data) ->
          # $('#daikyu_index_search_modal').modal('hide');

          if data.current_kintai.joutaimei == null
            current_joutaimei = ''
          else
            current_joutaimei = data.current_kintai.joutaimei

          if data.current_kintai.bikou == null
            current_bikou = ''
          else
            current_bikou = data.current_kintai.bikou

          if data.related_kintai.joutaimei == null
            related_joutaimei = ''
          else
            related_joutaimei = data.related_kintai.joutaimei

          if data.related_kintai.bikou == null
            related_bikou = ''
          else
            related_bikou = data.related_kintai.bikou

          if data.related_kintai2.joutaimei == null
            related_joutaimei2 = ''
          else
            related_joutaimei2 = data.related_kintai2.joutaimei

          if data.related_kintai2.bikou == null
            related_bikou2 = ''
          else
            related_bikou2 = data.related_kintai2.bikou

          if data.current_kintai.id != ''
            $('#best_in_place_kintai_'+data.current_kintai.id+'_状態1').text(current_joutaimei)
            $('#best_in_place_kintai_'+data.current_kintai.id+'_状態1').val(data.current_kintai.joutai)
            $('#bikou_'+data.current_kintai.id).text(current_bikou)
          if data.related_kintai.id != ''
            $('#best_in_place_kintai_'+data.related_kintai.id+'_状態1').text(related_joutaimei)
            $('#best_in_place_kintai_'+data.related_kintai.id+'_状態1').val(data.related_kintai.joutai)
            $('#bikou_'+data.related_kintai.id).text(related_bikou)
          if data.related_kintai2.id != ''
            $('#best_in_place_kintai_'+data.related_kintai2.id+'_状態1').text(related_joutaimei2)
            $('#best_in_place_kintai_'+data.related_kintai2.id+'_状態1').val(data.related_kintai2.joutai)
            $('#bikou_'+data.related_kintai2.id).text(related_bikou2)
          # alert(data.current_kintai.id+"\n"+data.current_kintai.joutai+"\n"+data.current_kintai.bikou+"\n"+data.related_kintai.id+"\n"+data.related_kintai.joutai+"\n"+data.related_kintai.bikou+"\n")

          # location.reload()
      });


  $(document).on('hide.bs.modal','#daikyu_index_search_modal', () ->
    if select_daikyu == 'false'
      $.ajax({
        type: 'PUT',
        url:  '/kintais/'+id_kintai,
        data: {kintai: {状態1: ''}},
        dataType: "JSON",
        success: (data) ->
          swal("振休の状態で代休相手日付を選択しなければなりません。")


          if data.current_kintai.joutaimei == null
            current_joutaimei = ''
          else
            current_joutaimei = data.current_kintai.joutaimei
          if data.current_kintai.bikou == null
            current_bikou = ''
          else
            current_bikou = data.current_kintai.bikou

          if data.related_kintai.joutaimei == null
            related_joutaimei = ''
          else
            related_joutaimei = data.related_kintai.joutaimei

          if data.related_kintai.bikou == null
            related_bikou = ''
          else
            related_bikou = data.related_kintai.bikou

          if data.related_kintai2.joutaimei == null
            related_joutaimei2 = ''
          else
            related_joutaimei2 = data.related_kintai2.joutaimei

          if data.related_kintai2.bikou == null
            related_bikou2 = ''
          else
            related_bikou2 = data.related_kintai2.bikou
          if data.current_kintai.id != ''
            $('#best_in_place_kintai_'+data.current_kintai.id+'_状態1').text(current_joutaimei)
            $('#best_in_place_kintai_'+data.current_kintai.id+'_状態1').val(data.current_kintai.joutai)
            $('#bikou_'+data.current_kintai.id).text(current_bikou)
          if data.related_kintai.id != ''
            $('#best_in_place_kintai_'+data.related_kintai.id+'_状態1').text(related_joutaimei)
            $('#best_in_place_kintai_'+data.related_kintai.id+'_状態1').val(data.related_kintai.joutai)
            $('#bikou_'+data.related_kintai.id).text(related_bikou)
          if data.related_kintai2.id != ''
            $('#best_in_place_kintai_'+data.related_kintai2.id+'_状態1').text(related_joutaimei2)
            $('#best_in_place_kintai_'+data.related_kintai2.id+'_状態1').val(data.related_kintai2.joutai)
            $('#bikou_'+data.related_kintai2.id).text(related_bikou2)
          # alert(data.current_kintai.id+"\n"+data.current_kintai.joutai+"\n"+data.current_kintai.bikou+"\n"+data.related_kintai.id+"\n"+data.related_kintai.joutai+"\n"+data.related_kintai.bikou+"\n")

          # location.reload()
          # $('#daikyu_index_search_modal').modal('hide');
      });
    else
      select_daikyu = 'false';
  );

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
    $('.summary').trigger('click')
  )

  # $('#gesshozan_btn').click () ->
  #   date = $('#search').val()
  #   if date == ''
  #     date = moment()
  #   else
  #     date = moment(date+"/01")
  #   tougetsu = date.format('YYYY/MM')
  #   jQuery.ajax({
  #     url: '/kintais/ajax',
  #     data: {id: 'gesshozan_calculate', zengetsu: date.subtract('months',1).format('YYYY/MM'),tougetsu: tougetsu},
  #     type: "POST",
  #     success: (data) ->
  #       $('.sum-yuukyu').text(data.getsumatsuzan)
  #       $('.input-number').val(data.gesshozan)
  #     failure: () ->
  #   })


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
        end_time += ' 19:30'
      when '007'
        start_time += ' 10:00'
        end_time += ' 20:00'
      when '008'
        start_time += ' 10:30'
        end_time += ' 20:30'
      when '009'
        start_time += ' 11:00'
        end_time += ' 21:00'
      when '010'
        start_time += ' 09:00'
        end_time += ' 14:00'
        real_time = 4
        $('#kintai_状態1').val('32')
        $('#kintai_状態1').parent().parent().find('p.joutai-code-hint').text('午後半休')
      when '011'
        start_time += ' 14:00'
        end_time += ' 18:00'
        real_time = 4
        $('#kintai_状態1').val('31')
        $('#kintai_状態1').parent().parent().find('p.joutai-code-hint').text('午前半休')
      else
        real_time = 0
    $('#kintai_出勤時刻').val(start_time)
    $('#kintai_退社時刻').val(end_time)

    $('#kintai_遅刻時間').val(0)
    # $('#kintai_普通保守時間').val(0)
    $('#kintai_深夜残業時間').val(0)
    # $('#kintai_深夜保守時間').val(0)
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

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
      $('#kintai_状態1').val('')
      $('.joutai-code-hint').text('')
      $('#kintai_代休相手日付').val('')
      $('#kintai_備考').val('')
    else
      oDaikyuTable.$('tr.selected').removeClass('selected')
      oDaikyuTable.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
      $('#kintai_状態1').val(fukyu_code)
      $('.joutai-code-hint').text(fukyu_name)
      $('#kintai_代休相手日付').val(d[0])

      if fukyu_code == '105'
        $('#kintai_備考').val(d[0] + 'の振休')
      else if fukyu_code == '109'
        $('#kintai_備考').val(d[0] + 'の午前振休')
      else if fukyu_code == '113'
        $('#kintai_備考').val(d[0] + 'の午後振休')

  $('#kintai_submit').on('click', (e) ->
    joutai = $('#kintai_状態1').val()
    if (joutai == "105"|| joutai == "109" || joutai == "113")&& $('#kintai_代休相手日付').val() == ''
      swal("振休の状態で代休相手日付を選択しなければなりません。")
      e.preventDefault()
  )
  kousu = []
  countup = 0
  until countup > 1000
    kousu.push(countup)
    countup += 0.5

  # $('#time-cal').on 'click', (event) ->
  #   start_time = $('#kintai_出勤時刻').val()
  #   end_time = $('#kintai_退社時刻').val()

  #   start_time_date = start_time.substring(0,10)
  #   end_time_date = end_time.substring(0,10)

  #   read_hours = 0
  #   fustu_zangyo = 0
  #   shinya_zangyou = 0

  #   shinya_diff = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time_date + ' 22:00', 'YYYY/MM/DD HH:mm'),'hours', true)
  #   if shinya_diff > 0
  #     for num in kousu
  #       if num > shinya_diff && num > 0
  #         shinya_zangyou = num - 0.5
  #         break

  #   fustu_zangyou_diff = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time_date + ' 19:00', 'YYYY/MM/DD HH:mm'),'hours', true)
  #   if fustu_zangyou_diff > 0
  #     for num in kousu
  #       if num > fustu_zangyou_diff && num > 0
  #         fustu_zangyo = num - 0.5
  #         break
  #   if fustu_zangyo > 3 then fustu_zangyo = 3

  #   fustu_end = end_time
  #   fustu_start = start_time
  #   if moment(end_time, 'YYYY/MM/DD HH:mm') > moment(start_time_date + ' 18:00', 'YYYY/MM/DD HH:mm') then fustu_end = start_time_date + ' 18:00'
  #   if moment(start_time, 'YYYY/MM/DD HH:mm') > moment(start_time_date + ' 12:00', 'YYYY/MM/DD HH:mm') && moment(start_time, 'YYYY/MM/DD HH:mm') < moment(start_time_date + ' 13:00', 'YYYY/MM/DD HH:mm') then fustu_start = start_time_date + ' 13:00'

  #   fustu_diff = moment(fustu_end, 'YYYY/MM/DD HH:mm').diff(moment(fustu_start, 'YYYY/MM/DD HH:mm'),'hours', true)
  #   if moment(start_time_date + ' 12:00', 'YYYY/MM/DD HH:mm') > moment(start_time, 'YYYY/MM/DD HH:mm') then fustu_diff -= 1

  #   if fustu_diff > 0
  #     for num in kousu
  #       if num > fustu_diff && num > 0
  #         read_hours = num - 0.5
  #         break

  #   read_hours += fustu_zangyo + shinya_zangyou
  #   if joutaikubun == '2'
  #     $('#kintai_遅刻時間').val('0')
  #   $('#kintai_実労働時間').val(read_hours)
  #   $('#kintai_普通残業時間').val(fustu_zangyo)
  #   $('#kintai_深夜残業時間').val(shinya_zangyou)
  #   $('#kintai_深夜保守時間').val()

  $('#time-cal').on 'click', (event) ->

    real_hours = 0
    fustu_zangyo = 0
    shinya_zangyou = 0
    hiru_kyukei = 0
    yoru_kyukei = 0
    shinya_kyukei = 0
    souchou_kyukei = 0

    start_time = $('#kintai_出勤時刻').val()
    end_time = $('#kintai_退社時刻').val()

    start_time_date = start_time.substring(0,10)
    end_time_date = end_time.substring(0,10)

    nextDay = moment(start_time_date).add('days',1)
    next_time_date = moment(nextDay).format("YYYY-MM-DD")


    hiru_kyukei_start =     start_time_date + ' 12:00'
    hiru_kyukei_end =       start_time_date + ' 13:00'
    yoru_kyukei_start =     start_time_date + ' 18:00'
    yoru_kyukei_end =       start_time_date + ' 19:00'
    shinya_kyukei_start =   start_time_date + ' 23:00'
    shinya_kyukei_end =     next_time_date + ' 00:00'
    souchou_kyukei_start =  next_time_date + ' 04:00'
    souchou_kyukei_end =    next_time_date + ' 07:00'

    hiru_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(hiru_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if hiru_diff_1 > 0
      for num in kousu
        if num > hiru_diff_1 && num > 0
          hiru_diff_1 = num - 0.5
          break
      hiru_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(hiru_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if hiru_diff_2 <= 0
        hiru_kyukei = hiru_diff_1
      else
        for num in kousu
          if num > hiru_diff_2 && num > 0
            hiru_diff_2 = num - 0.5
            break
        hiru_kyukei = hiru_diff_1 - hiru_diff_2

    yoru_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(yoru_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if yoru_diff_1 > 0
      for num in kousu
        if num > yoru_diff_1 && num > 0
          yoru_diff_1 = num - 0.5
          break
      yoru_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(yoru_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if yoru_diff_2 <= 0
        yoru_kyukei = yoru_diff_1
      else
        for num in kousu
          if num > yoru_diff_2 && num > 0
            yoru_diff_2 = num - 0.5
            break
        yoru_kyukei = yoru_diff_1 - yoru_diff_2

    shinya_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if shinya_diff_1 > 0
      for num in kousu
        if num > shinya_diff_1 && num > 0
          shinya_diff_1 = num - 0.5
          break
      shinya_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if shinya_diff_2 <= 0
        shinya_kyukei = shinya_diff_1
      else
        for num in kousu
          if num > shinya_diff_2 && num > 0
            shinya_diff_2 = num - 0.5
            break
        shinya_kyukei = shinya_diff_1 - shinya_diff_2

    souchou_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(souchou_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if souchou_diff_1 > 0
      for num in kousu
        if num > souchou_diff_1 && num > 0
          souchou_diff_1 = num - 0.5
          break
      souchou_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(souchou_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if souchou_diff_2 <= 0
        souchou_kyukei = souchou_diff_1
      else
        for num in kousu
          if num > souchou_diff_2 && num > 0
            souchou_diff_2 = num - 0.5
            break
        souchou_kyukei = souchou_diff_1 - souchou_diff_2

    real_hours = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time, 'YYYY/MM/DD HH:mm'),'hours', true)
    for num in kousu
      if num > real_hours && num > 0
        real_hours = num - 0.5
        break
    real_hours = real_hours - hiru_kyukei - yoru_kyukei - shinya_kyukei - souchou_kyukei
    if real_hours < 0
      real_hours = 0
    if shinya_kyukei > 0
      fustu_zangyo = moment(shinya_kyukei_start, 'YYYY/MM/DD HH:mm').diff(moment(start_time, 'YYYY/MM/DD HH:mm'),'hours', true)
      for num in kousu
        if num > fustu_zangyo && num > 0
          fustu_zangyo = num - 0.5
          break
      fustu_zangyo = fustu_zangyo - hiru_kyukei - yoru_kyukei - 8
    else
      fustu_zangyo = real_hours - 8
      if fustu_zangyo < 0
        fustu_zangyo = 0

    if souchou_kyukei > 0
      shinya_zangyou = moment(souchou_kyukei_start, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      for num in kousu
        if num > shinya_zangyou && num > 0
          shinya_zangyou = num - 0.5
          break
    else
      shinya_zangyou = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if shinya_zangyou < 0
        shinya_zangyou = 0
      else
        for num in kousu
          if num > shinya_zangyou && num > 0
            shinya_zangyou = num - 0.5
            break
    kinmutype = $('#kintai_勤務タイプ').val()
    start_time_default = start_time_date
    end_time_default = start_time_date
    switch (kinmutype)
      when '001'
        start_time_default += ' 07:00'
        end_time_default += ' 16:00'
      when '002'
        start_time_default += ' 07:30'
        end_time_default += ' 16:30'
      when '003'
        start_time_default += ' 08:00'
        end_time_default += ' 17:00'
      when '004'
        start_time_default += ' 08:30'
        end_time_default += ' 17:30'
      when '005'
        start_time_default += ' 09:00'
        end_time_default += ' 18:00'
      when '006'
        start_time_default += ' 09:30'
        end_time_default += ' 19:30'
      when '007'
        start_time_default += ' 10:00'
        end_time_default += ' 20:00'
      when '008'
        start_time_default += ' 10:30'
        end_time_default += ' 20:30'
      when '009'
        start_time_default += ' 11:00'
        end_time_default += ' 21:00'
    if kinmutype != ''
      chikoku = moment(start_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time_default, 'YYYY/MM/DD HH:mm'),'hours', true)
      if chikoku > 0
        for num in kousu
          if num > chikoku && num > 0
            chikoku = num - 0.5
            break
      else
        chikoku = 0

      soutai = moment(end_time_default, 'YYYY/MM/DD HH:mm').diff(moment(end_time, 'YYYY/MM/DD HH:mm'),'hours', true)
      if soutai > 0
        for num in kousu
          if num > soutai && num > 0
            soutai = num - 0.5
            break
      else
        soutai = 0
      chikoku_soutai = soutai + chikoku
    else
      chikoku_soutai = 0
    $('#kintai_実労働時間').val(real_hours)
    $('#kintai_遅刻時間').val(chikoku_soutai)
    $('#kintai_普通残業時間').val(fustu_zangyo)
    $('#kintai_深夜残業時間').val(shinya_zangyou)
    #$('#kintai_普通保守時間').val(yoru_kyukei)
    # $('#kintai_深夜保守時間').val(shinya_kyukei)

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
  $('#modal_print_kintai').click( () ->
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
  $('.input-time').datetimepicker({
      format: 'HH:mm'
    })
  $('.input-time').click( () ->
    $(this).closest('.time').data("DateTimePicker").toggle();
  );

  $('.time').on('dp.change', (e) ->
    idRow = $(this).find('.input-time').attr('id')
    idKintai = idRow.substring(12,idRow.length)
    date = $('#date'+idKintai).text()
    time = $(this).find('.input-time').val()
    start_input = $("#shukkinjikoku"+idKintai).val()
    end_input = $("#taishajikoku"+idKintai).val()
    start_time = date + " " +start_input
    if time >= "00:00" && time <= "07:00"
      nextDay = moment(date).add('days',1)
      date = moment(nextDay).format("YYYY-MM-DD")
    if end_input == ''
      end_time = ''
    else
      end_time = date + " " + end_input
    if start_input != '' && end_input != ''
      calculater(start_time,end_time,idKintai)
    else if start_input == ''
      jQuery.ajax({
        url: '/kintais/ajax',
        data: {id: 'update_endtime', timeEnd: end_time, idKintai: idKintai},
        type: "POST",
        success: (data) ->
  #       console.log("update_endtime success")
        failure: () ->
          console.log("update_endtime field")
      })
    else if end_input == ''
      update_when_time_null(start_time,end_time,idKintai)
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
  $('.input-time-start').datetimepicker({
      format: 'HH:mm'
    })
  $('.input-time-start').click( () ->
    $(this).closest('.timestart').data("DateTimePicker").toggle();
  );

  $('.timestart').on('dp.change', (e) ->
    idRow = $(this).find('.input-time-start').attr('id')
    idKintai = idRow.substring(13,idRow.length)
    date = $('#date'+idKintai).text()
    time = $(this).find('.input-time-start').val()
    #alert(date+" "+ time)
    start_input = $("#shukkinjikoku"+idKintai).val()
    end_input = $("#taishajikoku"+idKintai).val()
    if start_input == ''
      start_time = ''
    else
      start_time = date + " " +start_input
    if end_input >= "00:00" && end_input <= "07:00"
      nextDay = moment(date).add('days',1)
      date = moment(nextDay).format("YYYY/MM/DD")
    end_time = date + " " + end_input
    if start_input != '' && end_input != ''
      calculater(start_time,end_time,idKintai)
    else if end_input == ''
      jQuery.ajax({
        url: '/kintais/ajax',
        data: {id: 'update_starttime', timeStart: start_time, idKintai: idKintai},
        type: "POST",
        success: (data) ->
  #       console.log("update_endtime success")
        failure: () ->
          console.log("update_endtime field")
      })
    else if start_input == ''
      update_when_time_null(start_time,end_time,idKintai)

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
        $('#best_in_place_kintai_'+idKintai+"_実労働時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_遅刻時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_普通残業時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_深夜残業時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_普通保守時間").text('')
        $('#best_in_place_kintai_'+idKintai+"_深夜保守時間").text('')
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
      summary()
    )
  );

  # $('.input-number').on('change', () ->
  #   summary()
  # )

  # $('input').keydown( (e) ->
  #   if e.keyCode == 13
  #     if $('.input-number').is( ":focus" )
  #       e.preventDefault();
  #       $('.input-number').blur();
  # );

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

  calculater = (start_time, end_time, idKintai) ->
    joutai = $("#joutai"+idKintai).attr("value")
    real_hours = 0
    fustu_zangyo = 0
    shinya_zangyou = 0
    hiru_kyukei = 0
    yoru_kyukei = 0
    shinya_kyukei = 0
    souchou_kyukei = 0
    start_time_date = start_time.substring(0,10)
    end_time_date = end_time.substring(0,10)

    nextDay = moment(start_time_date).add('days',1)
    next_time_date = moment(nextDay).format("YYYY-MM-DD")


    hiru_kyukei_start =     start_time_date + ' 12:00'
    hiru_kyukei_end =       start_time_date + ' 13:00'
    yoru_kyukei_start =     start_time_date + ' 18:00'
    yoru_kyukei_end =       start_time_date + ' 19:00'
    shinya_kyukei_start =   start_time_date + ' 23:00'
    shinya_kyukei_end =     next_time_date + ' 00:00'
    souchou_kyukei_start =  next_time_date + ' 04:00'
    souchou_kyukei_end =    next_time_date + ' 07:00'

    hiru_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(hiru_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if hiru_diff_1 > 0
      for num in kousu
        if num > hiru_diff_1 && num > 0
          hiru_diff_1 = num - 0.5
          break
      hiru_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(hiru_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if hiru_diff_2 <= 0
        hiru_kyukei = hiru_diff_1
      else
        for num in kousu
          if num > hiru_diff_2 && num > 0
            hiru_diff_2 = num - 0.5
            break
        hiru_kyukei = hiru_diff_1 - hiru_diff_2

    yoru_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(yoru_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if yoru_diff_1 > 0
      for num in kousu
        if num > yoru_diff_1 && num > 0
          yoru_diff_1 = num - 0.5
          break
      yoru_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(yoru_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if yoru_diff_2 <= 0
        yoru_kyukei = yoru_diff_1
      else
        for num in kousu
          if num > yoru_diff_2 && num > 0
            yoru_diff_2 = num - 0.5
            break
        yoru_kyukei = yoru_diff_1 - yoru_diff_2

    shinya_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if shinya_diff_1 > 0
      for num in kousu
        if num > shinya_diff_1 && num > 0
          shinya_diff_1 = num - 0.5
          break
      shinya_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if shinya_diff_2 <= 0
        shinya_kyukei = shinya_diff_1
      else
        for num in kousu
          if num > shinya_diff_2 && num > 0
            shinya_diff_2 = num - 0.5
            break
        shinya_kyukei = shinya_diff_1 - shinya_diff_2

    souchou_diff_1 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(souchou_kyukei_start, 'YYYY/MM/DD HH:mm'),'hours', true)
    if souchou_diff_1 > 0
      for num in kousu
        if num > souchou_diff_1 && num > 0
          souchou_diff_1 = num - 0.5
          break
      souchou_diff_2 = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(souchou_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if souchou_diff_2 <= 0
        souchou_kyukei = souchou_diff_1
      else
        for num in kousu
          if num > souchou_diff_2 && num > 0
            souchou_diff_2 = num - 0.5
            break
        souchou_kyukei = souchou_diff_1 - souchou_diff_2

    real_hours = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time, 'YYYY/MM/DD HH:mm'),'hours', true)
    if real_hours > 0
      for num in kousu
        if num > real_hours && num > 0
          real_hours = num - 0.5
          break
    real_hours = real_hours - hiru_kyukei - yoru_kyukei - shinya_kyukei - souchou_kyukei
    if real_hours < 0
      real_hours = 0
    if shinya_kyukei > 0
      fustu_zangyo = moment(shinya_kyukei_start, 'YYYY/MM/DD HH:mm').diff(moment(start_time, 'YYYY/MM/DD HH:mm'),'hours', true)
      if fustu_zangyo >0
        for num in kousu
          if num > fustu_zangyo && num > 0
            fustu_zangyo = num - 0.5
            break
      fustu_zangyo = fustu_zangyo - hiru_kyukei - yoru_kyukei - 8
    else
      fustu_zangyo = real_hours - 8
    if fustu_zangyo < 0
      fustu_zangyo = 0

    if souchou_kyukei > 0
      shinya_zangyou = moment(souchou_kyukei_start, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if shinya_zangyou >0
        for num in kousu
          if num > shinya_zangyou && num > 0
            shinya_zangyou = num - 0.5
            break
      else
        shinya_zangyou = 0
    else
      shinya_zangyou = moment(end_time, 'YYYY/MM/DD HH:mm').diff(moment(shinya_kyukei_end, 'YYYY/MM/DD HH:mm'),'hours', true)
      if shinya_zangyou < 0
        shinya_zangyou = 0
      else
        for num in kousu
          if num > shinya_zangyou && num > 0
            shinya_zangyou = num - 0.5
            break

    #alert(real_hours + "\n"+ fustu_zangyo+ "\n"+ shinya_zangyou+"\n"+hiru_kyukei+ "\n"+yoru_kyukei+ "\n" + shinya_kyukei + "\n" +souchou_kyukei)
    kinmutype = $('#'+idKintai).text()
    start_time_default = start_time_date
    end_time_default = start_time_date
    switch (kinmutype)
      when '001'
        start_time_default += ' 07:00'
        end_time_default += ' 16:00'
      when '002'
        start_time_default += ' 07:30'
        end_time_default += ' 16:30'
      when '003'
        start_time_default += ' 08:00'
        end_time_default += ' 17:00'
      when '004'
        start_time_default += ' 08:30'
        end_time_default += ' 17:30'
      when '005'
        start_time_default += ' 09:00'
        end_time_default += ' 18:00'
      when '006'
        start_time_default += ' 09:30'
        end_time_default += ' 19:30'
      when '007'
        start_time_default += ' 10:00'
        end_time_default += ' 20:00'
      when '008'
        start_time_default += ' 10:30'
        end_time_default += ' 20:30'
      when '009'
        start_time_default += ' 11:00'
        end_time_default += ' 21:00'
    if kinmutype != ''
      chikoku = moment(start_time, 'YYYY/MM/DD HH:mm').diff(moment(start_time_default, 'YYYY/MM/DD HH:mm'),'hours', true)
      if chikoku > 0
        for num in kousu
          if num > chikoku && num > 0
            chikoku = num - 0.5
            break
      else
        chikoku = 0

      soutai = moment(end_time_default, 'YYYY/MM/DD HH:mm').diff(moment(end_time, 'YYYY/MM/DD HH:mm'),'hours', true)
      if soutai > 0
        for num in kousu
          if num > soutai && num > 0
            soutai = num - 0.5
            break
      else
        soutai = 0
      chikoku_soutai = soutai + chikoku
    else
      chikoku_soutai = 0
    $('#best_in_place_kintai_'+idKintai+"_実労働時間").text(real_hours)
    $('#best_in_place_kintai_'+idKintai+"_遅刻時間").text(chikoku_soutai)
    $('#best_in_place_kintai_'+idKintai+"_普通残業時間").text(fustu_zangyo)
    $('#best_in_place_kintai_'+idKintai+"_深夜残業時間").text(shinya_zangyou)
    #$('#best_in_place_kintai_'+idKintai+"_普通保守時間").text(yoru_kyukei)
    $('#best_in_place_kintai_'+idKintai+"_深夜保守時間").text(shinya_kyukei)

    jQuery.ajax({
      url: '/kintais/ajax',
      data: {id: 'update_time', timeStart: start_time,timeEnd: end_time, idKintai: idKintai,real_hours: real_hours, fustu_zangyo: fustu_zangyo,shinya_zangyou: shinya_zangyou,yoru_kyukei: yoru_kyukei, shinya_kyukei: shinya_kyukei, chikoku_soutai: chikoku_soutai},
      type: "POST",
      success: (data) ->
        console.log("update_endtime success")
      failure: () ->
        console.log("update_endtime field")
    })

  update_when_time_null = (start_time, end_time, idKintai) ->
    real_hours = ''
    fustu_zangyo = ''
    shinya_zangyou = ''
    hiru_kyukei = ''
    yoru_kyukei = ''
    shinya_kyukei = ''
    souchou_kyukei = ''
    chikoku_soutai = ''
    $('#best_in_place_kintai_'+idKintai+"_実労働時間").text(real_hours)
    $('#best_in_place_kintai_'+idKintai+"_遅刻時間").text(chikoku_soutai)
    $('#best_in_place_kintai_'+idKintai+"_普通残業時間").text(fustu_zangyo)
    $('#best_in_place_kintai_'+idKintai+"_深夜残業時間").text(shinya_zangyou)
    #$('#best_in_place_kintai_'+idKintai+"_普通保守時間").text(yoru_kyukei)
    $('#best_in_place_kintai_'+idKintai+"_深夜保守時間").text(shinya_kyukei)

    jQuery.ajax({
      url: '/kintais/ajax',
      data: {id: 'update_time', timeStart: start_time,timeEnd: end_time, idKintai: idKintai,real_hours: real_hours, fustu_zangyo: fustu_zangyo,shinya_zangyou: shinya_zangyou,yoru_kyukei: yoru_kyukei, shinya_kyukei: shinya_kyukei, chikoku_soutai: chikoku_soutai},
      type: "POST",
      success: (data) ->
        console.log("update_endtime success")
      failure: () ->
        console.log("update_endtime field")
    })
  $('#import_kintai').click( () ->
    $('#import_kintais_modal').modal('show')
    )
