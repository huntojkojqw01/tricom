jQuery ->
  oTable = $('#event_table').DataTable
    dom: "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-8'B><'col-md-4'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>"
    pagingType: "full_numbers"
    oLanguage:
      sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
    aoColumnDefs: [
      {
        aTargets: [0]
        bSortable: false
        bVisible: false
        bSearchable: false
      }
    ]
    oSearch:
      sSearch: queryParameters().search
    buttons: [
      {
        extend: 'copyHtml5',
        text: '<i class="fa fa-files-o"></i>',
        titleAttr: 'Copy'
        exportOptions:
          columns: [2,3,4,5,6,7,8,9]
      }
      {
        extend: 'excelHtml5',
        text: '<i class="fa fa-file-excel-o"></i>',
        titleAttr: 'Excel'
        exportOptions:
          columns: [2,3,4,5,6,7,8,9]
      }
      {
        extend: 'csvHtml5',
        text: '<i class="fa fa-file-text-o"></i>',
        titleAttr: 'CSV'
        exportOptions:
          columns: [2,3,4,5,6,7,8,9]
      }
      {
        text: '<i class="fa fa-upload"></i>',
        titleAttr: 'Import',
        action: (e, dt, node, config )->
          $('#import-csv-modal').modal('show')
      }
      {
        extend: 'selectAll'
        attr:
          id: 'all'
        action: (e, dt, node, config)->
          dt.rows().select()
          $("#edit").addClass("disabled")
          $("#delete").removeClass("disabled")
      }
      {
        extend: 'selectNone'
        attr:
          id: 'none'
        action: (e, dt, node, config)->
          dt.rows().deselect()
          $("#edit").addClass("disabled")
          $("#delete").addClass("disabled")
      }
      {
        text: 'New'
        attr:
          id: 'new'
        action: (e, dt, node, config)->
          window.location = '/events/new'
      }
      {
        text: 'Delete'
        attr:
          id: 'delete'
          class: 'dt-button disabled'
        action: (e, dt, node, config)->
          datas = dt.rows('tr.selected').data()
          ids = new Array()
          if datas.length == 0
            swal('行を選択してください。')
          else
            swal({
              title: '削除して宜しいですか？',
              text: "",
              type: "warning",
              showCancelButton: true,
              confirmButtonColor: "#DD6B55",
              confirmButtonText: "OK",
              cancelButtonText: "キャンセル",
              closeOnConfirm: false,
              closeOnCancel: false
            })
            .then(
              ()->
                datas.each (element, index)->
                  ids[index] = element[0]
                $.ajax
                  url: '/events/id'
                  data:
                    ids: ids
                  type: 'delete'
                  success: (data)->
                    swal("削除されました!", "", "success")
                    dt.rows('tr.selected').remove().draw()
                  failure: ()->
                    console.log("削除する Unsuccessful")
                $("#edit").addClass("disabled")
                $("#delete").addClass("disabled")
              ,(dismiss)->
                if dismiss == 'cancel'
                  selects = dt.rows('tr.selected').data()
                  if selects.length == 0
                    $("#edit").addClass("disabled")
                    $("#delete").addClass("disabled")
                  else
                    $("#delete").removeClass("disabled")
                    if selects.length == 1
                      $("#edit").removeClass("disabled")
                    else
                      $("#edit").addClass("disabled")
              )
      }
      {
        text: 'データ出力'
        attr:
          id: 'export_event'
        action: (e, dt, node, config)->
          window.location = '/events/export_csv.csv?locale=ja'
      }
    ]
  $('#event_table').on 'click', 'tbody tr', ()->
    $(this).toggleClass('selected')
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit").addClass("disabled")
      $("#delete").addClass("disabled")
      $(".buttons-select-none").addClass('disabled')
    else
      $("#delete").removeClass("disabled");
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit").removeClass("disabled")
      else
        $("#edit").addClass("disabled")