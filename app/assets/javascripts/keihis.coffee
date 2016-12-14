# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $(document).on 'click', '.keihihead-update', (event) ->
    summary()
  $(document).on 'click', '.summary', (event) ->
    summary()

#  sonotha_sum, koutsuhi_sum, nittou_sum, shukuhaku_sum, shinsheino
  summary = () ->
    sonotha_sum = 0
    koutsuhi_sum = 0
    nittou_sum = 0
    shukuhaku_sum = 0

    $('.koutsuhi').each( () ->
      value = $(this).val()
      if(!isNaN(value) && value.length != 0)
        koutsuhi_sum += parseFloat(value)
    )

    $('.nittou').each( () ->
      value = $(this).val()
      if(!isNaN(value) && value.length != 0)
        nittou_sum += parseFloat(value)
    )

    $('.shukuhaku').each( () ->
      value = $(this).val()
      if(!isNaN(value) && value.length != 0)
        shukuhaku_sum += parseFloat(value)
    )

    $('.sonotha').each( () ->
#    //var value = $(this).text()
      value = $(this).val()
#    // add only if the value is number
      if(!isNaN(value) && value.length != 0)
        sonotha_sum += parseFloat(value)
    )

    hansikin = $('#keihihead_仮払金').val()
    shikyuhin = $('#keihihead_支給品').val()

    if(!isNaN(hansikin) && hansikin.length != 0) then hansikin = $('#keihihead_仮払金').val() else hansikin = 0

    if(!isNaN(shikyuhin) && shikyuhin.length != 0) then shikyuhin = $('#keihihead_支給品').val() else shikyuhin = 0

#    //minue value for checked remove
    _sonotha_sum = 0
    _koutsuhi_sum = 0
    _nittou_sum = 0
    _shukuhaku_sum = 0
    $('.check-remove').each( () ->
      if ($(this).val() == "1")
        value = $(this).closest('tr').find('.koutsuhi').val()
        if(!isNaN(value) && value.length != 0)
          _koutsuhi_sum += parseFloat(value)

        value = $(this).closest('tr').find('.nittou').val()
        if(!isNaN(value) && value.length != 0)
          _nittou_sum += parseFloat(value)

        value = $(this).closest('tr').find('.shukuhaku').val()
        if(!isNaN(value) && value.length != 0)
          _shukuhaku_sum += parseFloat(value)

        value = $(this).closest('tr').find('.sonotha').val()
        if(!isNaN(value) && value.length != 0)
          _sonotha_sum += parseFloat(value)
    )

    koutsuhi_sum -= _koutsuhi_sum
    nittou_sum -= _nittou_sum
    shukuhaku_sum -= _shukuhaku_sum
    sonotha_sum -= _sonotha_sum

    $('#keihihead_交通費合計').val(koutsuhi_sum)
    $('#keihihead_日当合計').val(nittou_sum)
    $('#keihihead_宿泊費合計').val(shukuhaku_sum)
    $('#keihihead_その他合計').val(sonotha_sum)
    $('#keihihead_旅費合計').val(koutsuhi_sum + nittou_sum + shukuhaku_sum)
    $('#keihihead_合計').val(koutsuhi_sum + nittou_sum + shukuhaku_sum + sonotha_sum)
    $('#keihihead_過不足').val(koutsuhi_sum + nittou_sum + shukuhaku_sum + sonotha_sum - hansikin - shikyuhin)

    shinsheino = $('#keihihead_申請番号').val()
    $('.shinsheino').val(shinsheino)


  $(document).on 'click', '.delete-all', (event) ->
    $('.check-remove').each () ->
      $(this).val('1')
      $(this).closest('tr').hide()
      
      $('#keihihead_交通費合計').val(0)
      $('#keihihead_日当合計').val(0)
      $('#keihihead_宿泊費合計').val(0)
      $('#keihihead_その他合計').val(0)
      $('#keihihead_旅費合計').val(0)
      $('#keihihead_合計').val(0)
      $('#keihihead_過不足').val(0)
      $('#keihihead_仮払金').val(0)
    event.preventDefault()

  $(document).on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
#    $(this).closest('fieldset').remove()
    event.preventDefault()

  $(document).on 'click', '.remove_row', (event) ->
    $(this).closest('tr').find('.check-remove').val('1')
    $(this).closest('tr').hide()
    event.preventDefault()

  $(document).on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $(document).on 'click', '.add_row', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $('#keihi-table').find('tr').last().after($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    
  $(document).on 'focus', '.datepicker', (event) ->
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

  $(document).on 'click', '#keihi-table tr', (event) ->
    $('#keihi-table tr.selected').removeClass('selected')
    $(this).addClass('selected')
    event.preventDefault

  $(document).on 'click', '.atesaki-search', (event) ->
    $('#kaisha-search-modal').modal('show')
    event.preventDefault()

  $(document).on 'click', '.job-search', (event) ->
    $('#job_search_modal').modal('show')
    event.preventDefault()

  $('#kaisha-table-modal tbody').on 'click', 'tr', (event) ->
    d = oKaisha_search_modal.row(this).data()
    $('#keihi-table tr.selected').find('.atesaki-name').val(d[1])
  
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKaisha_search_modal.$('tr.selected').removeClass('selected')
      oKaisha_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $('#job_table tbody').on 'click', 'tr', (event) ->
    d = oJob_search_modal.row(this).data()
    $('#keihi-table tr.selected').find('.job-code').val(d[0])
  
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oJob_search_modal.$('tr.selected').removeClass('selected')
      oJob_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $(document).on 'click', '.kikan-search', (event) ->
    $('#kikan-search-modal').modal('show')
    event.preventDefault()

  $('#kikan-table-modal tbody').on 'click', 'tr', (event) ->
    d = oKikan_search_modal.row(this).data()
    $('#keihi-table tr.selected').find('.kikan-name').val(d[1])
  
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oKikan_search_modal.$('tr.selected').removeClass('selected')
      oKikan_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  eki = ''
  $('#eki-table-modal tbody').on 'click', 'tr', (event) ->
    d = oEki_search_modal.row(this).data()
    if eki is '1'
      $('#keihi-table tr.selected').find('.hastu-name').val(d[1])
    else
      $('#keihi-table tr.selected').find('.chaku-name').val(d[1])
      
    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oEki_search_modal.$('tr.selected').removeClass('selected')
      oEki_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
      
  $(document).on 'click', '.hastu-search', (event) ->
    eki = '1'
    $('#eki-search-modal').modal('show')
    event.preventDefault()

  $(document).on 'click', '.chaku-search', (event) ->
    eki = '2'
    $('#eki-search-modal').modal('show')
    event.preventDefault()

#  init modal table
  oShonin_search_modal = $('#shonin-table-modal').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }})
  
  $('#shonin-table-modal tbody').on 'click', 'tr', (event) ->
    d = oShonin_search_modal.row(this).data()
    $('.shonin').val(d[1])

    if ( $(this).hasClass('selected') )
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShonin_search_modal.$('tr.selected').removeClass('selected')
      oShonin_search_modal.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')

  $(document).on 'click', '.shonin-search', (event) ->
    $('#shonin-search-modal').modal('show')
    event.preventDefault()

  oShonin_table = $('.shonin-table').DataTable({
    "pagingType": "simple_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    },
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 13 ]},
      {
        "targets": [13],
        "width": '4%'
      }
    ]
  })

  $('.shonin-table').on( 'click', 'tr',  () ->
    d = oShonin_table.row(this).data()
    $('#jobmaster_ユーザ番号').val(d[0])
    $('#jobmaster_ユーザ名').val(d[1])

    if $(this).hasClass('selected')
      $(this).removeClass('selected')
      $(this).removeClass('success')
    else
      oShonin_table.$('tr.selected').removeClass('selected')
      oShonin_table.$('tr.success').removeClass('success')
      $(this).addClass('selected')
      $(this).addClass('success')
  )

  $(document).on 'focus', '#search', (event) ->
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

  $('.keihihead-table').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
    ,"aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 7,8 ]},
      {
        "targets": [7,8],
        "width": '5%'
      }
    ],
    "order": [],
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
  })

  $('.input-group').datetimepicker({
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

  $('#summary').click( () ->
    alert('now')
  )