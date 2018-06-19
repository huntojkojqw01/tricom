jQuery ->
  $.fn.modal_success = ()->
    this.modal('hide')
    #clear form input elements
    #note: handle textarea, select, etc
    this.find('form input[type="text"]').val('')
    #clear error state
    this.clear_previous_errors()
  $.fn.render_form_errors = (model, errors)->
    this_form = this
    $.each JSON.parse(errors), (attr, messages)->
      form_group = this_form.find('.' + model + '_' + attr)
      form_group.addClass('has-error')
      help_block = form_group.find('.help-block')
      $.each messages, (index, mess)->
        help_block.append(mess + '<br>')
  $.fn.clear_previous_errors = ()->
    $('.form-group.has-error', this).each ()->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
  window.create_sentaku_modal = (modal, table, ok_button, clear_button, trigger_name)->
    data_table = table.DataTable
      retrieve: true
      pagingType: 'full_numbers'
      oLanguage:
        sUrl: '/assets/resource/dataTable_' + $('#language').text() + '.txt'

    modal.on 'show', (e, code)->
      row_can_tim = data_table.row (idx, data, node)->
        if data[0] == code then true else false
      if row_can_tim.length > 0
        data_table.$('tr.selected').removeClass('selected')
        $(row_can_tim.node()).addClass('selected')
        data_table.page.jumpToData(code, 0)
        ok_button.attr('disabled', false)
        clear_button.attr('disabled', false)
      $(this).modal('show')

    table.on 'click', 'tbody>tr', ()->
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        ok_button.attr('disabled', true)
        clear_button.attr('disabled', true)
      else
        data_table.$('tr.selected').removeClass('selected')
        $(this).addClass('selected')
        ok_button.attr('disabled', false)
        clear_button.attr('disabled', false)

    table.on 'dblclick', 'tbody>tr', ()->
      $(this).addClass('selected')
      selected_data = data_table.row('tr.selected').data()
      table.trigger trigger_name, [selected_data]
      modal.modal('hide')

    clear_button.click ()->
      data_table.$('tr.selected').removeClass('selected')
      ok_button.attr('disabled', true)
      clear_button.attr('disabled', true)

    ok_button.click ()->
      selected_data = data_table.row('tr.selected').data()
      table.trigger trigger_name, [selected_data]

  window.create_datatable = (args)->
    oTable = $(args.table_id).DataTable({
      dom: "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>"
      scrollX: true
      pagingType: "full_numbers"
      oLanguage:
        sUrl: "/assets/resource/dataTable_"+$('#language').text()+".txt"
      aoColumnDefs: [
        {
          aTargets: args.no_sort_columns
          bSortable: false
        }
        {
          aTargets: args.invisible_columns
          bVisible: false
        }
        {
          aTargets: args.no_search_columns
          bSearchable: false
        }
      ]
      oSearch:
        sSearch: args.search_params
      scrollCollapse: true
      pageLength: args.page_length
      buttons: [
        {
          extend: 'copyHtml5',
          text: '<i class="fa fa-files-o"></i>',
          titleAttr: 'Copy'
        },
        {
          extend: 'excelHtml5',
          text: '<i class="fa fa-file-excel-o"></i>',
          titleAttr: 'Excel'
        },
        {
          extend: 'csvHtml5',
          text: '<i class="fa fa-file-text-o"></i>',
          titleAttr: 'CSV'
        },
        {
          text: '<i class="fa fa-upload"></i>',
          titleAttr: 'Import',
          action: (e, dt, node, config )->
            $('#import-csv-modal').modal('show')
        },
        {
          extend: 'selectAll'
          attr:
            id: 'all'
          action: (e, dt, node, config)->
            dt.rows().select()
            $("#edit").addClass("disabled")
            $("#delete").removeClass("disabled")
        },
        {
          extend: 'selectNone'
          attr:
            id: 'none'
          action: (e, dt, node, config)->
            dt.rows().deselect()
            $("#edit").addClass("disabled")
            $("#delete").addClass("disabled")
        },
        {
          text: 'New'
          attr:
            id: 'new'
          action: (e, dt, node, config)->
            if args.new_path != undefined
              window.location = args.new_path
            else
              $(args.new_modal_id).trigger 'show', []
        },
        {
          text: 'Edit'
          attr:
            id: 'edit'
            class: 'dt-button disabled'
          action: (e, dt, node, config)->
            data_of_selected_row = dt.row('tr.selected').data()
            if data_of_selected_row == undefined
              swal("行を選択してください。")
            else
              if args.edit_path != undefined
                window.location = args.edit_path.replace('/id/', "/#{args.get_id_from_row_data(data_of_selected_row)}/")
              else
                $(args.edit_modal_id).trigger 'show', [data_of_selected_row]
        },
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
                    ids[index] = args.get_id_from_row_data(element)
                  $.ajax
                    url: args.delete_path
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
      ],
      order: args.order_columns
    })

    $(args.table_id).on 'click', 'tbody tr', ()->
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
