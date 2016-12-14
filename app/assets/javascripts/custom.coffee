jQuery ->
#  $("form").on("keypress",  (e) ->
#    if (e.keyCode == 13)
#      false
#  )

#  $('.glyphicon-calendar').datetimepicker({
#    format: 'YYYY/MM/DD',
#    widgetPositioning: {
#      horizontal: 'left'
#    }
#    ,showTodayButton: true
#    ,showClear: true
#    ,calendarWeeks: true,
#    keyBinds: false,
#    focusOnShow: false
#  })
  $(document).on 'click', '.glyphicon-calendar', (event) ->
    $(this).datetimepicker({
      format: 'YYYY/MM/DD',
      widgetPositioning: {
        horizontal: 'left',
        vertical: 'bottom'
      }
      showTodayButton: true,
      showClear: true,
#    //,daysOfWeekDisabled:[0,6]
      calendarWeeks: true,
      keyBinds: false,
      focusOnShow: false

    })
    event.preventDefault()
