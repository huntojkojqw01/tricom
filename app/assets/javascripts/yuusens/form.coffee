jQuery ->
  $('#yuusen_色').colorpicker()

  $('#yuusen_色').colorpicker().on 'changeColor', (ev)->
    $('#preview-backgroud').css("background-color", ev.color.toHex())
    $(this).val(ev.color.toHex())

  $('#preview-backgroud').css("background-color", $("#yuusen_色").val())
