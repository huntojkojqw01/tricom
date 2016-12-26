# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oEkiTable = $('.ekitable').DataTable({
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    }
    ,
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    }]
  })

  $("#edit_eki").attr("disabled", true);
  $("#destroy_eki").attr("disabled", true);

  $('.ekitable').on( 'click', 'tr',  () ->
    d = oEkiTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        $("#edit_eki").attr("disabled", true);
        $("#destroy_eki").attr("disabled", true);
      else
        oEkiTable.$('tr.selected').removeClass('selected')
        oEkiTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        $("#edit_eki").attr("disabled", false);
        $("#destroy_eki").attr("disabled", false);
  )

  $('#destroy_eki').click () ->
    eki_id = oEkiTable.row('tr.selected').data()

    if eki_id == undefined
      alert($('#message_confirm_select').text())
    else
      response = confirm($('#message_confirm_delete').text())
      if response
        $.ajax({
          url: '/ekis/ajax',
          data:{
            focus_field: 'eki_削除する',
            eki_id: eki_id[0]
          },

          type: "POST",

          success: (data) ->
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              $(".ekitable").dataTable().fnDeleteRow($('.ekitable').find('tr.selected').remove())
              $(".ekitable").dataTable().fnDraw()

            else
              console.log("getAjax destroy_success:"+ data.destroy_success)


          failure: () ->
            console.log("eki_削除する keydown Unsuccessful")

        })
    $("#edit_eki").attr("disabled", true);
    $("#destroy_eki").attr("disabled", true);

  $('#new_eki').click () ->
    $('#eki-new-modal').modal('show')
    $('#eki_駅コード').val('')
    $('#eki_駅名').val('')
    $('#eki_駅名カナ').val('')

  $('#edit_eki').click () ->
    eki_id = oEkiTable.row('tr.selected').data()
    if eki_id == undefined
      alert("行を選択してください。")
    else
      $('#eki-edit-modal').modal('show')
      $('#eki_駅コード').val(eki_id[0])
      $('#eki_駅名').val(eki_id[1])
      $('#eki_駅名カナ').val(eki_id[2])
      $("#edit_eki").attr("disabled", true);
      $("#destroy_eki").attr("disabled", true);