jQuery ->
  $.fn.modal_success = ()->
    this.modal('hide')
    #clear form input elements
    #note: handle textarea, select, etc
    this.find('form input[type="text"]').val('')
    #clear error state
    this.clear_previous_errors()
  $.fn.render_form_errors = (errors) ->
    this.clear_previous_errors()
    model = this.data('model')
    $.each(errors, (field, messages) ->
      $input = $('input[name="' + model + '[' + field + ']"]')
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') )
      $select = $('select[name="' + model + '[' + field + ']"]')
      $select.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') )
    )
  $.fn.clear_previous_errors = () ->
    $('.form-group.has-error', this).each( () ->
      $('.help-block', $(this)).html('')
      $(this).removeClass('has-error')
    )
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
  $.fn.setStandardTable = (object,ajax_url)->
    oTable = $('.'+object+'table').DataTable({
      "dom": 'lBfrtip',
      "pagingType": "simple_numbers",
      "oLanguage":{
        "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
      },
      "oSearch": {"sSearch": queryParameters().search},
      "buttons": [
        {
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
              $("#edit_"+object).attr("disabled", true);
              $("#destroy_"+object).attr("disabled", true);
            else
              $("#destroy_"+object).attr("disabled", false);
              if selects.length == 1
                $("#edit_"+object).attr("disabled", false);
              else
                $("#edit_"+object).attr("disabled", true);
            $(".buttons-select-none").removeClass('disabled')
        },
        {
          "extend": 'selectNone',
          "action": ( e, dt, node, config ) ->
            oTable.$('tr').removeClass('selected')
            oTable.$('tr').removeClass('success')
            selects = oTable.rows('tr.selected').data()
            if selects.length == 0
              $("#edit_"+object).attr("disabled", true);
              $("#destroy_"+object).attr("disabled", true);
            else
              $("#destroy_"+object).attr("disabled", false);
              if selects.length == 1
                $("#edit_"+object).attr("disabled", false);
              else
                $("#edit_"+object).attr("disabled", true);
            $(".buttons-select-none").addClass('disabled')
        }
      ]
    })
    $("#edit_"+object).attr("disabled", true)
    $("#destroy_"+object).attr("disabled", true)
    $('.'+object+'table').on 'click', 'tr',  () ->
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
        $("#edit_"+object).attr("disabled", true)
        $("#destroy_"+object).attr("disabled", true)
        $(".buttons-select-none").addClass('disabled')
      else
        $("#destroy_"+object).attr("disabled", false)
        $(".buttons-select-none").removeClass('disabled')
        if selects.length == 1
          $("#edit_"+object).attr("disabled", false)
        else
          $("#edit_"+object).attr("disabled", true)
    $('#destroy_'+object).click () ->
      rows = oTable.rows('tr.selected').data()
      objectIds = new Array();
      if rows.length == 0
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
          len = rows.length
          for i in [0...len]
            objectIds[i] = rows[i][0]
          $.ajax({
            url: ajax_url,
            data:{
              focus_field: object+'_削除する',
              datas: objectIds
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
              console.log(object+"_削除する keydown Unsuccessful")
          })
          $("#edit_"+object).attr("disabled", true);
          $("#destroy_"+object).attr("disabled", true);
        ,(dismiss) ->
          if dismiss == 'cancel'
            selects = oTable.rows('tr.selected').data()
            if selects.length == 0
              $("#edit_"+object).attr("disabled", true);
              $("#destroy_"+object).attr("disabled", true);
            else
              $("#destroy_"+object).attr("disabled", false);
              if selects.length == 1
                $("#edit_"+object).attr("disabled", false);
              else
                $("#edit_"+object).attr("disabled", true);
        );
    return oTable