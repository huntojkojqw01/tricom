$(function(){
  $('.datetime-start').datetimepicker({
    format: 'YYYY/MM/DD',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    keyBinds: false,
    focusOnShow: false
  });

  $('.datetime-end').datetimepicker({
    format: 'YYYY/MM/DD',
    showTodayButton: true,
    showClear: true,
    sideBySide: true,
    keyBinds: false,
    focusOnShow: false
  });


  $('#keihi_shuppi_seisanbi_start').click(function(){
    $('.datetime-start').data("DateTimePicker").toggle();
  });
  $('#keihi_shuppi_seisanbi_end').click(function(){
    $('.datetime-end').data("DateTimePicker").toggle();
  });
  $('#kensaku_keihi').click(function(){
    timeStart = $('#keihi_shuppi_seisanbi_start').val();
    timeEnd = $('#keihi_shuppi_seisanbi_end').val();
    order = $('#head_順位').val()
    if(timeStart != '' && timeEnd != '')
      location.href = '/keihiheads/show_keihi_shuppi?locale=ja'+"&timeStart="+timeStart+"&timeEnd="+timeEnd+"&order="+order
    else
      swal("清算予定日からと清算予定日までを入力してください")
  })
});