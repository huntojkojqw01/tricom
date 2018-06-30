jQuery ->
  $('#kintai_勤務タイプ').on 'change', ()->
    selected_val = $('#kintai_勤務タイプ').val()
    selected_val = '001' if selected_val == "" || selected_val == null
    date = new Date($('#kintai_出勤時刻').val())
    date = new Date() if isNaN(date.getTime())   
    start_time = moment(date).format('YYYY/MM/DD') + ' ' + KINMU[selected_val].st
    end_time = moment(date).format('YYYY/MM/DD') + ' ' + KINMU[selected_val].et
    switch selected_val      
      when '010'
        real_time = 4
        $('#kintai_状態1').val('32')
        $('#kintai_状態1').parent().parent().find('p.joutai-code-hint').text('午後半休')
      when '011'
        real_time = 4
        $('#kintai_状態1').val('31')
        $('#kintai_状態1').parent().parent().find('p.joutai-code-hint').text('午前半休')
      else
        real_time = 8
    $('#kintai_出勤時刻').val(start_time)
    $('#kintai_退社時刻').val(end_time)
    $('#kintai_遅刻時間').val(0)
    $('#kintai_深夜残業時間').val(0)
    $('#kintai_実労働時間').val(real_time)
    $('#kintai_普通残業時間').val(0)

  $('.datetime').datetimepicker
    format: 'YYYY/MM/DD HH:mm'
    showTodayButton: true
    showClear: true
    sideBySide: true
    toolbarPlacement: 'top'
    keyBinds: false
    focusOnShow: false
  $('#kintai_出勤時刻').click ()->
    $('.kintai_出勤時刻 .datetime').data("DateTimePicker").toggle()
  $('#kintai_退社時刻').click ()->
    $('.kintai_退社時刻 .datetime').data("DateTimePicker").toggle()

  $('#time-cal').on 'click', (event) ->
    results = time_calculate($('#kintai_出勤時刻').val(), $('#kintai_退社時刻').val(), $('#kintai_勤務タイプ').val())
    koushuu = results.real_hours + results.fustu_zangyo + results.shinya_zangyou
    # Kiem tra xem joutai dang chon co duoc tinh zangyou hay khong, neu khong thi set zangyou ve 0
    row = $('#joutai_table').DataTable().row (idx, data, node)->
      if data[0] == $('#kintai_状態1').val() then true else false
    if row.length > 0 && row.data()[4] == '1'
      results.fustu_zangyo = 0.0
      results.shinya_zangyou = 0.0
    $('#kintai_実労働時間').val(koushuu)
    $('#kintai_遅刻時間').val(results.chikoku_soutai)
    $('#kintai_普通残業時間').val(results.fustu_zangyo)
    $('#kintai_深夜残業時間').val(results.shinya_zangyou)

  setup_tab_render_name
    input: $('#kintai_状態1')
    output: $('.joutai-code-hint')
    table: $('#joutai_table')

  $('.refer-joutai').click (e)->
    e.preventDefault()
    input = $(this).prev()
    $('#joutai_search_modal').trigger('show', [input.val()])

  $('#joutai_table').on 'choose_joutai', (e, selected_data)->
    if selected_data != undefined
      # fill data to this input
      if DAIKYU_JOUTAIS.includes(selected_data[0]) #振替勤務, 午前振出, 午後振出
        $.post
          url: '/kintais/ajax'
          data:
            id: 'get_kintais'
            joutai: selected_data[0]
          success: (data) ->
            console.log("OK")
          failure: ()->
            console.log("NG")
      else
        $('#kintai_状態1').val(selected_data[0])
        $('.joutai-code-hint').text(selected_data[1])
        $('#kintai_状態1').closest('.form-group').find('span.help-block').remove()
        $('#kintai_状態1').closest('.form-group').removeClass('has-error')

  $('#daikyu_table').on 'choose_daikyu', (e, selected_data)->
    if selected_data != undefined
      $('#kintai_代休相手日付').val(selected_data[0])
