jQuery ->
  $('#shozai_background_color').colorpicker()
  $('#shozai_text_color').colorpicker()

  $('#shozai_background_color').colorpicker().on 'changeColor', (ev)->
    $('#preview-backgroud').css("background-color", ev.color.toHex())
    $(this).val(ev.color.toHex())

  $('#shozai_text_color').colorpicker().on 'changeColor', (ev)->
    $('#preview-text').css("color", ev.color.toHex())
    $(this).val(ev.color.toHex())

  $("#preview-text").css('color', $("#shozai_text_color").val())
  $('#preview-backgroud').css("background-color", $("#shozai_background_color").val())