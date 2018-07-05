setsubiyoyaku_timeline = undefined

updateEvent = (the_event) ->
  jQuery.ajax
    url: '/setsubiyoyakus/ajax'
    data:
      focus_field: 'setsubiyoyaku_update'
      eventId: the_event.id
      event_start: the_event.start.format('YYYY/MM/DD HH:mm')
      event_end: the_event.end.format('YYYY/MM/DD HH:mm')
    type: 'POST'
    success: (data) ->
      console.log 'Update success'
      return
    failure: ->
      console.log 'Update unsuccessful'
      return
  $('#setsubiyoyaku-timeline').fullCalendar 'updateEvent', the_event
  return

showModal = (date) ->
  setsubiCode = $('#head_setsubicode').val()
  window.open '/setsubiyoyakus/new?start_at=' + date + '&setsubi_code=' + setsubiCode, '_self'

changeTitleFormat = (inputTitleFormat) ->
  indx = inputTitleFormat.indexOf('–')
  if indx > 0
    insert inputTitleFormat, indx - 1, '日'
  else
    inputTitleFormat

insert = (str, index, value) ->
  str.substr(0, index) + value + str.substr(index)

$ ->
  setsubi = $('#head_setsubicode').val()
  param = '&head[setsubicode]=' + setsubi
  $.getJSON '/setsubiyoyakus?' + param, (data) ->
    setsubiyoyaku_timeline = $('#setsubiyoyaku-timeline').fullCalendar(
      schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives'
      firstDay: 1
      height: 600
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
      header:
        left: 'title'
        right: 'today,prev,next'
      titleFormat: 'YYYY年MM月(DD日)'
      viewRender: (view, element) ->
        date = view.title
        date = changeTitleFormat(date)
        $('#setsubiyoyaku-timeline .fc-left').replaceWith '<div class= "fc-left"><h2>' + date + '</h2></div>'
        return
      aspectRatio: 1.5
      resourceAreaWidth: '15%'
      slotLabelFormat: [ 'HH : mm' ]
      nowIndicator: true
      defaultView: 'agendaWeek'
      scrollTime: '09:00'
      dragOpacity: '0.5'
      editable: true
      events: data.setsubiyoyakus
      timeFormat: 'HH:mm'
      defaultDate: moment($('#selected_date').val())
      eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
        # alert(event.title + " was dropped on " + event.start.format());
        updateEvent event
        return
      eventResize: (event, dayDelta, minuteDelta, revertFunc) ->
        updateEvent event
        return
      dayRender: (date, element, view) ->
        # element.append("<button id='bt-new-"+date.format()+"' onclick='createEvent(\""+date.format()+"\"); return false;' "+
        #                 "class='btn btn-primary' type='button'>新規</button>");
        setsubiCode = $('#head_setsubicode').val()
        # element.append("<button id='bt-new-"+date.format()+"' onclick='showModal(\""+date.format()+"\"); return false;' "+
        #                 "value=1 class='btn btn-primary' type='button'>新規</button>");
        element.append '<div class= "click-able"><a href="/setsubiyoyakus/new?start_at=' + date.format() + '&setsubi_code=' + setsubiCode + '" style="margin-right: 10px" class= "nomal"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>' + '<a href="/setsubiyoyakus/new?start_at=' + date.format() + '&all_day=true&setsubi_code=' + setsubiCode + '" style="" class= "full-day"><span class="glyphicon glyphicon-time" aria-hidden="true"></span></a></div>'
        # element.append('<a href="/setsubiyoyakus/new?start_at='+date.format()+'&all_day=true&setsubi_code='+setsubiCode+
        #     '" style="" class= ""><span class="glyphicon glyphicon-time" aria-hidden="true"></span></a>');
        # el.html('<a href="/events/new?shain_id='+resources.shainid+'"></a>');
        return
      eventAfterRender: (event, element, view) ->
        # var bottom = parseInt(element.closest('.fc-time-grid-event').css("bottom"),10);
        # var top = parseInt(element.closest('.fc-time-grid-event').css("top"),10);
        # var margin = (-(top + bottom)/2).toString()+"px";
        height = parseInt(element.closest('.fc-time-grid-event').css('height'), 10)
        contentHeight = parseInt(element.find('.fc-content').css('height'), 10)
        margin = ((height - contentHeight) / 2).toString() + 'px'
        element.find('.fc-content').css 'margin-top', margin
        return
      eventMouseover: (event, jsEvent, view) ->
        tooltip = '<div class="tooltipevent hover-end">'
        tooltip += '<div>' + event.start.format('YYYY/MM/DD HH:mm') + '</div>'
        tooltip += '<div>' + event.end.format('YYYY/MM/DD HH:mm') + '</div>'
        tooltip += '<div>' + event.shain + '</div>'
        tooltip += '<div>' + event.yoken + '</div>'
        tooltip += '<div>' + event.description + '</div>'
        tooltip += '</div>'
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
    )
    setsubiyoyaku_timeline.find('.fc-today-button,.fc-prev-button,.fc-next-button').click ->
      $('#setsubiyoyaku_table').DataTable().draw()
      $.post '/settings/ajax',
        setting: 'setting_date'
        selected_date: $('#setsubiyoyaku-timeline').fullCalendar('getDate').format()
      return
    return
  #Add tooltip
  $(document).on 'mouseover', '.nomal', (e) ->
    tooltip = '<div class="tooltipevent hover-end"><div>普通時間</div></div>'
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
  $(document).on 'mouseout', '.nomal', (e) ->
    $(this).css 'z-index', 8
    $('.tooltipevent').remove()
    return
  #Add tooltip
  $(document).on 'mouseover', '.full-day', (e) ->
    tooltip = '<div class="tooltipevent hover-end"><div>終日時間</div></div>'
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
  $(document).on 'mouseout', '.full-day', (e) ->
    $(this).css 'z-index', 8
    $('.tooltipevent').remove()
    return
  # $('html, body').animate({scrollTop:$(document).height()/2});
  return

  setsubi = $('#head_setsubicode').val()
  param = '&head[setsubicode]=' + setsubi
  setInterval (->
    $.getJSON '/setsubiyoyakus?' + param, (data) ->
      setsubiyoyaku_timeline.fullCalendar 'removeEvents'
      setsubiyoyaku_timeline.fullCalendar 'addEventSource', data.setsubiyoyakus
      setsubiyoyaku_timeline.fullCalendar 'rerenderEvents'
      return
    return
  ), 9000
  return