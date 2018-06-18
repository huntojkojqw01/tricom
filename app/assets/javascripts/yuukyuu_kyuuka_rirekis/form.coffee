jQuery ->
  $('.datetime').datetimepicker({
    format: 'YYYY/MM',
    viewMode: 'months',
    keyBinds: false,
    focusOnShow: false
    }).on('dp.show', ()->
        $('.datetime').data("DateTimePicker").viewMode("months")
    );
  $('#yuukyuu_kyuuka_rireki_年月').click ()->
    $('.datetime').data("DateTimePicker").viewMode("months").toggle()