jQuery ->
  $('#joutaimaster_色').colorpicker()
  $('#joutaimaster_text_color').colorpicker()

  $('#joutaimaster_色').colorpicker().on 'changeColor', (ev)->
    $('#preview-backgroud').css("background-color", ev.color.toHex())
    $(this).val(ev.color.toHex())

  $('#joutaimaster_text_color').colorpicker().on 'changeColor', (ev)->
    $('#preview-text').css("color", ev.color.toHex())
    $(this).val(ev.color.toHex())

  $("#preview-text").css('color', $("#joutaimaster_text_color").val())
  $('#preview-backgroud').css("background-color", $("#joutaimaster_色").val())
