shain_old = ''
start_old = ''
end_old = ''
#init time title and joutai
weekday = [
  '日'
  '月'
  '火'
  '水'
  '木'
  '金'
  '土'
]

set_selected_date = ->
  $.post '/settings/ajax',
    setting: 'setting_date'
    selected_date: $('#calendar-timeline').fullCalendar('getDate').format('YYYY/MM/DD')

updateEvent = (the_event) ->
  the_event.url = '/events/' + the_event.id + '/edit.html?locale=ja&param=timeline&shain_id=' + the_event.resourceId
  $.post
    url: '/events/ajax'
    data:
      id: 'event_drag_update'
      shainId: the_event.resourceId
      eventId: the_event.id
      event_start: the_event.start.format('YYYY/MM/DD HH:mm')
      event_end: the_event.end.format('YYYY/MM/DD HH:mm')
    success: (data) ->
      console.log 'Update success'
    failure: ->
      console.log 'Update unsuccessful'
  $('#calendar-timeline').fullCalendar 'updateEvent', the_event

create_calendar = (data) ->
  flag = 0
  update_joutai_timeline = ->
    time = new Date
    $('#timeline_time').text moment(time).format('YYYY年M月D日 (ddd) HH:mm')
    selectedDate = $('#calendar-timeline').fullCalendar('getDate')
    selectedDate.hour time.getHours()
    selectedDate.minute time.getMinutes()
    #update joutai
    listShain = $('#calendar-timeline').fullCalendar('getResources')
    j = 0
    while j < listShain.length
      check_exist = false
      listEvents = $('#calendar-timeline').fullCalendar('getResourceEvents', listShain[j].id)
      i = 0
      while i < listEvents.length
        if moment(listEvents[i].start) <= selectedDate and selectedDate <= moment(listEvents[i].end)
          check_exist = true
          $('.fc-resource-area tr[data-resource-id="' + listEvents[i].resourceId + '"] td:nth-child(3) .fc-cell-content').css('color', listEvents[i].textColor).css 'background-color', listEvents[i].color
          $('.fc-resource-area tr[data-resource-id="' + listEvents[i].resourceId + '"] td:nth-child(3) .fc-cell-content>span').text listEvents[i].joutai
          $('.fc-resource-area tr[data-resource-id="' + listEvents[i].resourceId + '"] td:nth-child(4) .fc-cell-content>div>span').text listEvents[i].bashomei
          break
        i++
      if !check_exist
        $('.fc-resource-area tr[data-resource-id="' + listShain[j].id + '"] td:nth-child(3) .fc-cell-content').css('color', data.default.textColor).css 'background-color', data.default.color
        $('.fc-resource-area tr[data-resource-id="' + listShain[j].id + '"] td:nth-child(3) .fc-cell-content>span').text data.default.joutai
        $('.fc-resource-area tr[data-resource-id="' + listShain[j].id + '"] td:nth-child(4) .fc-cell-content>div>span').text ''
      j++

  calendar = $('#calendar-timeline').fullCalendar(
    customButtons:
      next10Days:
        text: '>+10'
        click: ->
          currentDate = $('#calendar-timeline').fullCalendar('getDate')
          next10Days = currentDate.add(10, 'days')
          $('#calendar-timeline').fullCalendar 'gotoDate', next10Days
        icon: 'right-double-arrow'
      prev10Days:
        text: '<-10'
        click: ->
          currentDate = $('#calendar-timeline').fullCalendar('getDate')
          prev10Days = currentDate.add(-10, 'days')
          $('#calendar-timeline').fullCalendar 'gotoDate', prev10Days
        icon: 'left-double-arrow'
    header: right: 'today prev,next, prev10Days,next10Days, timelineDay, timeline7Day'
    views:
      timeline7Day:
        type: 'timelineWeek'
        buttonText: '週'
        slotDuration: moment.duration(1, 'day')
        slotLabelFormat: [ 'M/D ddd' ]
        titleFormat: 'YYYY年M月D日 dd'
        timeFormat: 'HH'
      timelineDay: titleFormat: 'YYYY年M月D日 [(]dd[)]'
    viewRender: (view, element) ->
      date = view.title
      now = moment().format('YYYY/MM/DD')
      calendar_date = $('#calendar-timeline').fullCalendar('getDate').format('YYYY/MM/DD')
      if view.name == 'timeline7Day'
        date = view.title
      else if view.name == 'timelineDay'
        if now == calendar_date
          date = date + '  (今日)'
        else if now < calendar_date
          date = date + '  (予定)'
        else if now > calendar_date
          date = date + '  (過去)'
      $('#calendar-timeline .fc-left').replaceWith '<div class= "fc-left"><h2>' + date + '</h2></div>'
    schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives'
    lang: 'ja'
    height: 'auto'
    businessHours:
      start: '09:00:00'
      end: '18:00:00'
      dow: [
        0
        1
        2
        3
        4
        5
        6
      ]
    firstDay: 1
    nowIndicator: true
    aspectRatio: 1.5
    resourceAreaWidth: '30%'
    slotLabelFormat: [ 'HH : mm' ]
    scrollTime: data.setting.scrolltime
    eventOverlap: false
    defaultView: 'timelineDay'
    dragOpacity: '0.5'
    editable: true
    events: data.events
    defaultDate: moment($('#goto_date').val())
    eventDragStart: (event) ->
      flag = 1
      if event.bashokubun != 1
        selectedDate = $('#calendar-timeline').fullCalendar('getDate')
        calDate = moment(selectedDate).format()
        if event.start.isBefore(calDate) and event.end.isAfter(calDate)
          $('.fc-resource-area tr[data-resource-id="' + event.resourceId + '"] td:nth-child(2)').css 'color', 'rgb(51, 51, 51)'
      shain_old = event.resourceId
      start_old = event.start
      end_old = event.end
    eventDragStop: (event) ->
      flag = 0
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      if shain_old == event.resourceId
        updateEvent event
      else
        event.resourceId = shain_old
        event.start = start_old
        event.end = end_old
        revertFunc()
    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent event
    eventMouseover: (event, jsEvent, view) ->
      tooltip = '<div class="tooltipevent hover-end">' + '<div>' + event.start.format('YYYY/MM/DD HH:mm') + '</div>' + '<div>' + event.end.format('YYYY/MM/DD HH:mm') + '</div>' + '<div>' + event.title + '</div>' + '<div>' + event.bashomei + '</div>'
      if event.job != undefined
        tooltip = tooltip + '<div>' + event.job + '</div>'
      if event.comment != undefined
        tooltip = tooltip + '<div>' + event.comment + '</div>'
      tooltip = tooltip + '</div>'
      $('body').append tooltip
      $(this).mouseover((e) ->
        $(this).css 'z-index', 10000
        $('.tooltipevent').fadeIn '500'
        $('.tooltipevent').fadeTo '10', 1.9
      ).mousemove (e) ->
        $('.tooltipevent').css 'top', e.pageY + 10
        $('.tooltipevent').css 'left', e.pageX + 20
    eventMouseout: (event, jsEvent, view) ->
      $(this).css 'z-index', 8
      $('.tooltipevent').remove()
    resourceColumns: [
      {
        labelText: '社員名'
        field: 'shain'
        render: (resources, el) ->
          el.css 'background-color', '#67b168'
      }
      {
        labelText: '内線'
        field: 'linenum'
        width: 45
        render: (resources, el) ->
          el.css 'background-color', '#adadad'
      }
      {
        labelText: '状態'
        field: 'joutai'
        render: (resources, el) ->
          el.css('background-color', resources.background_color)
          el.css('color', resources.text_color)
      }
      {
        labelText: '場所'
        field: 'bashomei'
        render: (resources, el) ->
          el.css 'background-color', '#adadad'
          el.html '<div align="left"><span style="margin-right:10px"></span></div>'
      }
      {
        labelText: '伝言'
        field: 'dengon'
        width: 45
        render: (resources, el) ->
          el.css 'background-color', '#adadad'
          el.html '<div align="right"><span style="margin-right:10px">' + resources.dengon + '</span><a href="/dengons?head%5Bshainbango%5D=' + resources.id + '"><i class="glyphicon glyphicon-comment" aria-hidden="true" style="font-size:12px;"></i></a></div>'
      }
      {
        labelText: '回覧'
        field: 'kairan'
        width: 45
        render: (resources, el) ->
          el.css 'background-color', '#adadad'
          if resources.id == $('#user_login').val()
            el.html '<div align="right"><span style="margin-right:10px">' + resources.kairan + '</span><a href="/kairans?head%5Bshainbango%5D=' + resources.id + '">' + '<i class="glyphicon glyphicon-envelope" aria-hidden="true" style="font-size:12px;"></i></a></div>'
      }
      {
        labelText: ''
        field: 'shinki'
        width: 30
        render: (resources, el) ->
          el.html '<a href="/events/new?param=timeline&shain_id=' + resources.id + '&start_at=' + $('#calendar-timeline').fullCalendar('getDate').format('YYYY/MM/DD') + '" class="glyphicon glyphicon-edit" aria-hidden="true" style="font-size:12px;"></a>'
      }
    ]
    resources: data.shains)

  calendar.find('.fc-today-button, .fc-prev-button, .fc-next-button, .fc-next10Days-button, .fc-prev10Days-button').click ->
    #set current date to hidden field to goback, post it to session
    set_selected_date()

  calendar.find('.fc-timeline7Day-button').click ->
    calendar.find('.fc-next10Days-button, .fc-prev10Days-button').addClass 'fc-state-disabled'

  calendar.find('.fc-timelineDay-button').click ->
    calendar.find('.fc-next10Days-button, .fc-prev10Days-button').removeClass 'fc-state-disabled'

  update_joutai_timeline
  setInterval(update_joutai_timeline, 3000)

jQuery ->
  $('#create_kitaku_button').click ->
    time_start = moment().format('YYYY/MM/DD HH:mm')
    time_end = moment().add('m', 5).format('YYYY/MM/DD HH:mm')
    $.post
      url: '/events/ajax'
      data:
        id: 'create_kitaku_event'
        time_start: time_start
        time_end: time_end
      success: (data) ->
        if data.create_message == 'OK'
          location.reload()
        else
          swal '', '現在、未消化のイベントが、あります。イベント訂正後、再度、帰宅を入力してください。'
      failure: ->
        console.log 'Update unsuccessful'
  create_calendar(event_data) 