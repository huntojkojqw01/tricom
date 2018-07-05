jQuery ->
  if $('#head_setsubicode').val().length <= 0
    $('#setsubiyoyaku-timeline').hide()
    $('#show_table_button').hide()
  else
    $('#setsubiyoyaku-timeline').show()      
    $('#show_table_button').show()

  $('#head_setsubicode').change ()->
    $(this).closest('form').submit()

  $('#table-div').hide()
  $('#show_table_button').click ()->
    $('#table-div').toggle()  

  
