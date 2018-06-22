jQuery ->
  $('#setting_scrolltime').change ->
    scrolltime = $('#setting_scrolltime').val()
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "setting_scrolltime" ,scrolltime: scrolltime}
      success: (data) ->
        console.log 'Update setting scrolltime Successful'
      failure: () ->
        console.log 'Update setting scrolltim Unsuccessful'

  $('#setting_local').change ->
    local = $('#setting_local').val()
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "setting_local" ,local: local}
      success: (data) ->
        console.log 'Update setting local Successful'
        location.reload()
      failure: () ->
        console.log 'Update setting local Unsuccessful'
  $('#setting_local option:eq(1)').prepend('<img src="/assets/images/jp.jpeg" height="18" width="22">')
  $('#setting_local option:eq(2)').prepend('<img src="/assets/images/en.jpeg" height="18" width="22">')
  $('#setting_local option:eq(3)').prepend('<img src="/assets/images/vn.jpeg" height="18" width="22">')
  $('#setting_select_holiday_vn').change ->
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "select_holiday_vn" ,select_holiday_vn: @checked}
      success: (data) ->
        console.log 'Update setting holiday_vn Successful'
      failure: () ->
        console.log 'Update setting holiday_vn Unsuccessful'

  $('#setting_turning_data').change ->
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "turning_data" ,turning_data: @checked}
      success: (data) ->
        console.log 'Update setting turning data Successful'
      failure: () ->
        console.log 'Update setting turning data Unsuccessful'
