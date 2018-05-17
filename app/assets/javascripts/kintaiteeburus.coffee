# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $.fn.dataTable.ext.buttons.import =
  className: 'buttons-import'
  action: (e, dt, node, config) ->
    $('#import-csv-modal').modal('show')
  oTable = $('.kintaiteeburutable').DataTable({
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    "fnDrawCallback": (oSettings) ->
      $('.new-btn').appendTo($('.dt-buttons'));
      $('.edit-btn').appendTo($('.dt-buttons'));
      $('.delete-btn').appendTo($('.dt-buttons'));
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
                "titleAttr": 'CSV',
                exportOptions: {
                  columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
                }
            },
            {
                "extend":    'import',
                "text":      '<i class="glyphicon glyphicon-import"></i>',
                "titleAttr": 'Import'
            },
            {
              "extend": 'selectAll',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').addClass('selected')
                oTable.$('tr').addClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kintaiteeburu").addClass("disabled");
                  $("#destroy_kintaiteeburu").addClass("disabled");
                else
                  $("#destroy_kintaiteeburu").removeClass("disabled");
                  if selects.length == 1
                    $("#edit_kintaiteeburu").removeClass("disabled");
                  else
                    $("#edit_kintaiteeburu").addClass("disabled");
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_kintaiteeburu").addClass("disabled");
                  $("#destroy_kintaiteeburu").addClass("disabled");
                else
                  $("#destroy_kintaiteeburu").removeClass("disabled");
                  if selects.length == 1
                    $("#edit_kintaiteeburu").removeClass("disabled");
                  else
                    $("#edit_kintaiteeburu").addClass("disabled");
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_kintaiteeburu").addClass("disabled");
  $("#destroy_kintaiteeburu").addClass("disabled");

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
      $("#edit_kintaiteeburu").addClass("disabled");
      $("#destroy_kintaiteeburu").addClass("disabled");
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_kintaiteeburu").removeClass("disabled");
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_kintaiteeburu").removeClass("disabled");
      else
        $("#edit_kintaiteeburu").addClass("disabled");

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
        $("#edit_kintaiteeburu").addClass("disabled");
        $("#destroy_kintaiteeburu").addClass("disabled");

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_kintaiteeburu").addClass("disabled");
            $("#destroy_kintaiteeburu").addClass("disabled");
          else
            $("#destroy_kintaiteeburu").removeClass("disabled");
            if selects.length == 1
              $("#edit_kintaiteeburu").removeClass("disabled");
            else
              $("#edit_kintaiteeburu").addClass("disabled");
      );
  $('#edit_kintaiteeburu').click ->
    new_address = oTable.row('tr.selected').data()[12].split("\"")[1]
    if new_address == undefined
      swal("行を選択してください。")
    else
      window.location = new_address
  $("#kintaiteeburu_勤務タイプ").change ()->
    switch($(this).val())
      when "001"
        $("#kintaiteeburu_出勤時刻_4i").val("07")
        $("#kintaiteeburu_出勤時刻_5i").val("00")

        $("#kintaiteeburu_退社時刻_4i").val("16")
        $("#kintaiteeburu_退社時刻_5i").val("00")
      when "002"
        $("#kintaiteeburu_出勤時刻_4i").val("07")
        $("#kintaiteeburu_出勤時刻_5i").val("30")

        $("#kintaiteeburu_退社時刻_4i").val("16")
        $("#kintaiteeburu_退社時刻_5i").val("30")
      when "003"
        $("#kintaiteeburu_出勤時刻_4i").val("08")
        $("#kintaiteeburu_出勤時刻_5i").val("00")

        $("#kintaiteeburu_退社時刻_4i").val("17")
        $("#kintaiteeburu_退社時刻_5i").val("00")
      when "004"
        $("#kintaiteeburu_出勤時刻_4i").val("08")
        $("#kintaiteeburu_出勤時刻_5i").val("30")

        $("#kintaiteeburu_退社時刻_4i").val("17")
        $("#kintaiteeburu_退社時刻_5i").val("30")
      when "005"
        $("#kintaiteeburu_出勤時刻_4i").val("09")
        $("#kintaiteeburu_出勤時刻_5i").val("00")

        $("#kintaiteeburu_退社時刻_4i").val("18")
        $("#kintaiteeburu_退社時刻_5i").val("00")
      when "006"
        $("#kintaiteeburu_出勤時刻_4i").val("09")
        $("#kintaiteeburu_出勤時刻_5i").val("30")

        $("#kintaiteeburu_退社時刻_4i").val("19")
        $("#kintaiteeburu_退社時刻_5i").val("30")
      when "007"
        $("#kintaiteeburu_出勤時刻_4i").val("10")
        $("#kintaiteeburu_出勤時刻_5i").val("00")

        $("#kintaiteeburu_退社時刻_4i").val("20")
        $("#kintaiteeburu_退社時刻_5i").val("00")
      when "008"
        $("#kintaiteeburu_出勤時刻_4i").val("10")
        $("#kintaiteeburu_出勤時刻_5i").val("30")

        $("#kintaiteeburu_退社時刻_4i").val("20")
        $("#kintaiteeburu_退社時刻_5i").val("30")
      when "009"
        $("#kintaiteeburu_出勤時刻_4i").val("11")
        $("#kintaiteeburu_出勤時刻_5i").val("00")

        $("#kintaiteeburu_退社時刻_4i").val("21")
        $("#kintaiteeburu_退社時刻_5i").val("00")