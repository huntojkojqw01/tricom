# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.kintaiteeburutable').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "aoColumnDefs": [ 
      { "bSortable": false, "aTargets": [ 0,12 ]},
      { "bSearchable": false, "aTargets": [ 0,12 ]},
      {
        "aTargets": [0,12],
        "visible": false
      }
    ],
    "oSearch": {"sSearch": queryParameters().search},

    "buttons": [{
                "extend":    'copyHtml5',
                "text":      '<i class="fa fa-files-o"></i>',
                "titleAttr": 'Copy'
            },
            {
                "extend":    'excelHtml5',
                "text":      '<i class="fa fa-file-excel-o"></i>',
                "titleAttr": 'Excel'
            },
            {
                "extend":    'csvHtml5',
                "text":      '<i class="fa fa-file-text-o"></i>',
                "titleAttr": 'CSV'
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kintaiteeburu").attr("disabled", true);
                  $("#destroy_kintaiteeburu").attr("disabled", true);
                else
                  $("#destroy_kintaiteeburu").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_kintaiteeburu").attr("disabled", false);
                  else
                    $("#edit_kintaiteeburu").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kintaiteeburu").attr("disabled", true);
                  $("#destroy_kintaiteeburu").attr("disabled", true);
                else
                  $("#destroy_kintaiteeburu").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_kintaiteeburu").attr("disabled", false);
                  else
                    $("#edit_kintaiteeburu").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_kintaiteeburu").attr("disabled", true);
  $("#destroy_kintaiteeburu").attr("disabled", true);

  $('.kintaiteeburutable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')        
      else       
        $(this).addClass('selected')
        $(this).addClass('success')       
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_kintaiteeburu").attr("disabled", true);
      $("#destroy_kintaiteeburu").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_kintaiteeburu").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_kintaiteeburu").attr("disabled", false);
      else
        $("#edit_kintaiteeburu").attr("disabled", true);

  )

  $('#destroy_kintaiteeburu').click () ->
    kintaiteeburus = oTable.rows('tr.selected').data()
    kintaiteeburuIds = new Array();
    if kintaiteeburus.length == 0
      swal($('#message_confirm_select').text())
    else

      swal({
        title: $('#message_confirm_delete').text(),
        text: "",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "OK",
        cancelButtonText: "キャンセル",
        closeOnConfirm: false,
        closeOnCancel: false
      }).then(() ->
        len = kintaiteeburus.length
        for i in [0...len]
          kintaiteeburuIds[i] = kintaiteeburus[i][0]

        $.ajax({
          url: '/kintaiteeburus/ajax',
          data:{
            focus_field: 'kintaiteeburu_削除する',
            kintaiteeburus: kintaiteeburuIds
          },

          type: "POST",

          success: (data) ->
            swal("削除されました!", "", "success");
            if data.destroy_success != null
              console.log("getAjax destroy_success:"+ data.destroy_success)
              oTable.rows('tr.selected').remove().draw()
            else
              console.log("getAjax destroy_success:"+ data.destroy_success)


          failure: () ->
            console.log("kintaiteeburu_削除する keydown Unsuccessful")

        })
        $("#edit_kintaiteeburu").attr("disabled", true);
        $("#destroy_kintaiteeburu").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_kintaiteeburu").attr("disabled", true);
            $("#destroy_kintaiteeburu").attr("disabled", true);
          else
            $("#destroy_kintaiteeburu").attr("disabled", false);
            if selects.length == 1
              $("#edit_kintaiteeburu").attr("disabled", false);
            else
              $("#edit_kintaiteeburu").attr("disabled", true);
      ); 
  $('#edit_kintaiteeburu').click ->      
    new_address = oTable.row('tr.selected').data()[12].split("\"")[1]    
    if new_address == undefined
      swal("行を選択してください。")
    else            
      window.location = new_address
  $('.datetime').datetimepicker({
    format: 'HH:mm'    
  })