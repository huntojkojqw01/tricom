parseDateValue = (rawDate) ->
  dateArray = rawDate.substring(0, 10).split('/')
  parsedDate = dateArray[0] + dateArray[1] + dateArray[2]
  parsedDate

isNum = (c) ->
  c >= '0' and c <= '9'

getStartCalendarMonthbegin = (dateString) ->
  #console.log(dateString.length);
  res = dateString.substring(0, 4)
  if dateString.charAt(5) == ' '
    if isNum(dateString.charAt(6)) and isNum(dateString.charAt(7))
      res += dateString.substring(6, 8)
    else
      res += '0' + dateString.substring(6, 7)
    res += '01'
  else
    if isNum(dateString.charAt(5)) and isNum(dateString.charAt(6))
      res += dateString.substring(5, 7)
      if isNum(dateString.charAt(8)) and isNum(dateString.charAt(9))
        res += dateString.substring(8, 10)
      else
        res += '0' + dateString.substring(8, 9)
    else
      res += '0' + dateString.substring(5, 6)
      if isNum(dateString.charAt(7)) and isNum(dateString.charAt(8))
        res += dateString.substring(7, 9)
      else
        res += '0' + dateString.substring(7, 8)
  res
$ ->
  dataTableExt = $.fn.dataTableExt.afnFiltering.push((oSettings, aData, iDataIndex) ->
    dateStart = getStartCalendarMonthbegin($('.fc-left').text())
    # var dateStart = parseDateValue($("#dateStart").val());
    # var dateEnd = parseDateValue($("#dateEnd").val());
    # aData represents the table structure as an array of columns, so the script access the date value
    # in the first column of the table via aData[0]
    evalDate = parseDateValue(aData[1])
    #show only this month
    if !moment(aData[1].substr(0, 10), 'YYYY/MM/DD', true).isValid()
      #check to inogle date coloumn
      return true
    else if evalDate.substr(0, 6) == dateStart.substr(0, 6)
      return true
    false
  )

showModal = (date, hoshukeitai) ->
  # if(bt_val==1) hoshukeitai=0;
  # else if(hoshukeitai=1;
  if hoshukeitai == '1'
    $('#bt-hoshu-1' + date).show()
    $('#bt-hoshu-0' + date).hide()
  else
    $('#bt-hoshu-1' + date).hide()
    $('#bt-hoshu-0' + date).show()
  if !date or !hoshukeitai
    return
  $.post
    url: '/events/ajax'
    data:
      id: 'kintai_保守携帯回数'
      hoshukeitai: hoshukeitai
      date_kintai: date
    success: (data) ->
      if data.kintai_id != null
        console.log 'getAjax kintai_id:' + data.kintai_id
      else
        console.log 'getAjax kintai_id:' + data.kintai_id
      return
    failure: ->
      console.log 'kintai_保守携帯回数 keydown Unsuccessful'
      return
  $('#bt-hoshu-1').show()
  $('#bt-hoshu-0').hide()
  return

updateEvent = (the_event) ->
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
  $('#calendar-month-view').fullCalendar 'updateEvent', the_event

create_calendar = (data) ->
  myEventSourses = ''
  if data.setting.select_holiday_vn == '1'
    myEventSourses = [
      {
        googleCalendarId: 'en.japanese#holiday@group.v.calendar.google.com'
        color: 'green'
      }
      {
        googleCalendarId: 'en.vietnamese#holiday@group.v.calendar.google.com'
        color: 'blue'
      }
    ]
  else
    myEventSourses = [ {
      googleCalendarId: 'en.japanese#holiday@group.v.calendar.google.com'
      color: 'green'
    } ]
  $('#calendar-month-view').fullCalendar
    schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives'
    firstDay: 1
    timeFormat: 'H:mm'
    slotLabelFormat: [ 'HH : mm' ]
    nowIndicator: true
    googleCalendarApiKey: 'AIzaSyDOeA5aJ29drd5dSAqv1TW8Dvy2zkYdsdk'
    eventSources: myEventSourses
    schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source'
    events: data.events
    header:
      left: 'title'
      center: 'month,agendaWeek,agendaDay today prev,next'
      right: ''
    dragOpacity: '0.5'
    editable: true
    defaultDate: moment($('#goto_date').val())
    viewRender: (view, element) ->
      jQuery.ajax
        url: '/events/ajax'
        data:
          id: 'kintai_getData'
          date_kintai: $('#calendar-month-view').fullCalendar('getDate').format()
        type: 'POST'
        success: (data) ->
          jQuery.each data, (key, val) ->
            cell = element.find('.fc-bg td.fc-day[data-date=' + key + ']')
            if cell.length > 0
              color = cell.css('background-color')
              cell.append '<button id=\'bt-hoshu-1' + key + '\' onclick=\'showModal("' + key + '","0"); return false;\' ' + 'value=1 class=\'btn btn-hoshu\' type=\'button\'>携帯</button>' + '<button id=\'bt-hoshu-0' + key + '\' onclick=\'showModal("' + key + '","1"); return false;\' ' + 'value=0 class=\'btn btn-text\' style=\'background-color:' + color + '\' type=\'button\'>携帯</button>'
              if val == 1
                $('#bt-hoshu-1' + key).show()
                $('#bt-hoshu-0' + key).hide()
              else
                $('#bt-hoshu-1' + key).hide()
                $('#bt-hoshu-0' + key).show()
            return
          return
        failure: ->
          console.log 'kintai_保守携帯回数 keydown Unsuccessful'
          return
      return
    dayClick: (date, jsEvent, view) ->
      #window.open('http://misuzu.herokuapp.com/events/new?start_at='+date.format());
      calendar = document.getElementById('calendar-month-view')

      calendar.ondblclick = ->
        location.href = '/events/new?start_at=' + date.format('YYYY/MM/DD')
        return

      #alert(data.sUrl);
      return
    dayRender: (date, element, view) ->
      # var date_convert = new Date(date.format());
      # if(date_convert.getDay()!==6 && date_convert.getDay()!==0&&hoshukeitai!=null)
      #     element.append("<a id='abc' value=100 onclick='showModal(\""+date.format()+"\"); return false;' style='cursor: pointer;'><i class='fa fa-pencil'>"+hoshukeitai+"</i></a>");
      # var date_convert = new Date(date.format());
      # if(date_convert.getDay()!==6 && date_convert.getDay()!==0)
      #     element.append("<a id='abc' onclick='showModal(\""+date.format()+"\"); return false;' style='cursor: pointer;'><i class='fa fa-pencil'>保守携帯</i></a>");
      return
    eventRender: (event, element, view) ->
      if view.name == 'agendaDay' or view.name == 'agendaWeek'
        if event.job != undefined or event.comment != undefined
          element.find('.fc-title').replaceWith '<div>' + event.job + '</div>' + '<div>' + event.comment + '</div>'
      return
    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      # alert(event.title + " was dropped on " + event.start.format());
      updateEvent event
      return
    eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
      updateEvent event
      return
    eventMouseover: (event, jsEvent, view) ->
      tooltip = '<div class="tooltipevent hover-end">' + '<div>' + event.start.format('YYYY/MM/DD HH:mm') + '</div>' + '<div>' + event.end.format('YYYY/MM/DD HH:mm') + '</div>'
      tooltip += '<div>' + event.title
      tooltip += (if event.job != undefined then ' ' + event.bashomei else '') + '</div>'
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
        return
      ).mousemove (e) ->
        $('.tooltipevent').css 'top', e.pageY + 10
        $('.tooltipevent').css 'left', e.pageX + 20
        return
      return
    eventMouseout: (event, jsEvent, view) ->
      $(this).css 'z-index', 8
      $('.tooltipevent').remove()
      return
  # end of $('#calendar-month-view').fullCalendar(
  #Hander calendar header button click
  $('#month-view').find('#goto-date-button, .fc-today-button,.fc-prev-button,.fc-next-button').click ->
    #redraw dataTable after filter
    oTable = $('#event_table').DataTable()
    oTable.draw()
    #set current date to hidden field to goback, post it to session
    $.post '/settings/ajax',
      setting: 'setting_date'
      selected_date: $('#calendar-month-view').fullCalendar('getDate').format('YYYY/MM/DD')
  #add jpt holiday
  $('#calendar-month-view').fullCalendar 'addEventSource', data.holidays

jQuery ->
  $('#shainmaster_kinmutype').on 'change', ()->
    $.post
      url: '/events/ajax'
      data:
        id: 'save_kinmu_type'
        data:$(this).val()
      success: (data) ->
#        swal('勤務タイプ保存！')
      failure: () ->
        console.log("save-kinmu-type field")

  $('#goto-date-input').val(moment().format('YYYY/MM/DD'))
  $('.datetime_search').datetimepicker
    format: 'YYYY/MM/DD'
    widgetPositioning:
      horizontal: 'left'
    showTodayButton: true
    showClear: true
    sideBySide: true
    keyBinds: false
    focusOnShow: false
  $('#goto-date-input').click ->
    $('.datetime_search').data("DateTimePicker").toggle()
  
  $('#goto-date-button').click ->
    date_input = $('#goto-date-input').val()
    date = moment(date_input)
    $('#calendar-month-view').fullCalendar 'gotoDate', date
    $('#calendar-timeline').fullCalendar 'gotoDate', date

  $('#search_user').click ()->
    $('#select_user_modal').trigger('show', [''])

  $('#user_table').on 'choose_shain', (e, selected_data)->
    if selected_data != undefined
      $('#selected_user').val(selected_data[0])
      $('#selected_user_name').val(selected_data[1])
      $('#selected_user').closest('form').submit()

  $('#event_button').click ()->
    $('#after_div').toggle()

  $('#after_div').hide()  

  create_calendar(event_data)
