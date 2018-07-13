jQuery ->
  window.KISHA_JOUTAIS = ['10', '11', '12', '13', '120', '121', '122', '103', '107', '111']
  window.DAIKYU_JOUTAIS = ['105', '109', '113']
  window.KINMU = {
    '000' : { s: 0, e: 23, st: '00:00', et: '23:00' },# tuong duong voi 00:00 -> 23:00
    '001' : { s: 7, e: 16, st: '07:00', et: '16:00'  },
    '002' : { s: 7.5, e: 16.5, st: '07:30', et: '16:30'  },
    '003' : { s: 8, e: 17, st: '08:00', et: '17:00'  },
    '004' : { s: 8.5, e: 17.5, st: '08:30', et: '17:30'  },
    '005' : { s: 9, e: 18, st: '09:00', et: '18:00'  },
    '006' : { s: 9.5, e: 19.5, st: '09:30', et: '19:30'  },
    '007' : { s: 10, e: 20, st: '10:00', et: '20:00'  },
    '008' : { s: 10.5, e: 20.5, st: '10:30', et: '20:30'  },
    '009' : { s: 11, e: 21, st: '11:00', et: '21:00'  },
    '010' : { s: 9, e: 14, st: '09:00', et: '14:00'  },
    '011' : { s: 14, e: 18, st: '14:00', et: '18:00'  }
  }
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
  window.create_sentaku_modal = (args)->
    data_table = args.table.DataTable
      retrieve: true
      pagingType: 'full_numbers'
      oLanguage:
        sUrl: '/assets/resource/dataTable_' + $('#language').text() + '.txt'
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
      order: args.order_columns
    args.modal.on 'show', (e, code)->
      row_can_tim = data_table.row (idx, data, node)->
        if data[0] == code then true else false
      if row_can_tim.length > 0
        data_table.$('tr.selected').removeClass('selected')
        $(row_can_tim.node()).addClass('selected')
        data_table.page.jumpToData(code, 0)
        args.ok_button.attr('disabled', false)
        args.clear_button.attr('disabled', false)
      $(this).modal('show')

    args.table.on 'click', 'tbody>tr', ()->
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        args.ok_button.attr('disabled', true)
        args.clear_button.attr('disabled', true)
      else
        data_table.$('tr.selected').removeClass('selected')
        $(this).addClass('selected')
        args.ok_button.attr('disabled', false)
        args.clear_button.attr('disabled', false)

    args.table.on 'dblclick', 'tbody>tr', ()->
      $(this).addClass('selected')
      selected_data = data_table.row('tr.selected').data()
      args.table.trigger args.trigger_name, [selected_data]
      args.modal.modal('hide')

    args.clear_button.click ()->
      data_table.$('tr.selected').removeClass('selected')
      args.ok_button.attr('disabled', true)
      args.clear_button.attr('disabled', true)

    args.ok_button.click ()->
      selected_data = data_table.row('tr.selected').data()
      args.table.trigger args.trigger_name, [selected_data]

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
          exportOptions:
            columns: args.csv_export_columns
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
          text: '新規'
          attr:
            id: 'new'
          action: (e, dt, node, config)->
            if args.new_path != undefined
              window.location = args.new_path
            else
              $(args.new_modal_id).trigger 'show', []
        },
        {
          text: '編集'
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
          text: '削除'
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
  # ham thuc hien chuc nang bam Tab thi se hien name tuong ung voi code 
  window.setup_tab_render_name = (args)->
    args.input.keydown (e)->
      if (e.keyCode == 9 && !e.shiftKey)
        code = $(this).val()
        table = args.table.DataTable()
        row = table.row (idx, data, node) ->
          if data[args.index_of_input || 0] == code then true else false
        tmp = if row.length > 0 then row.data()[args.index_of_output || 1] else ''
        if args.output.is('input')
          args.output.val(tmp)
        else
          args.output.text(tmp)

  # Ham tinh toan cac luong thoi gian nghi, thoi gian lam viec
  # theo kinmu_type (chu y 2 type dac biet la 010 va 011).
  # Thuat toan : vd de tinh thoi gian nghi trua (12:00->13:00):
  # don_vi_lam_tron = 30 // tuc la cu lam tron thoi gian 30 phut.
  # for i = start_time -> end_time
  #    nghi_trua_time += 0.5 if i % 30 == 12 
  #    i+=30 // tang them 30 phut
  kyuukei_time_calculate = (start, end)->
    hiru_kyukei = yoru_kyukei = shinya_kyukei = souchou_kyukei = real_hours = 0
    t = start
    while t + 30 <= end
      switch Math.floor(t / 60) % 24 # tinh xem thoi diem t ung voi may gio trong ngay.
        when 12 # tuong duong 12:00->13:00
          hiru_kyukei += 0.5
        when 18
          yoru_kyukei += 0.5
        when 23
          shinya_kyukei += 0.5
        when 4, 5, 6
          souchou_kyukei += 0.5
        else
          real_hours += 0.5
      t += 30
    return {
      hiru_kyukei: hiru_kyukei,
      yoru_kyukei: yoru_kyukei,
      shinya_kyukei: shinya_kyukei,
      souchou_kyukei: souchou_kyukei,
      real_hours: real_hours,
      fustu_zangyo: 0,
      shinya_zangyou: 0,
      chikoku_soutai: 0
    }
  zangyou_time_calculate = (start, end)->
    fustu_zangyo = shinya_zangyou = 0
    t = start
    while t + 30 <= end
      switch Math.floor(t / 60) % 24 # tinh xem thoi diem t ung voi may gio trong ngay.
        when 16, 17, 19, 20, 21, 22
          fustu_zangyo += 0.5
        when 0, 1, 2, 3
          shinya_zangyou += 0.5
      t += 30
    return [fustu_zangyo, shinya_zangyou]
  window.time_calculate = (start_time, end_time, kinmu_type)->
    # quy doi start_time, end_time ra phut
    start_time = new Date(start_time)
    end_time = new Date(end_time)
    return {} if isNaN(start_time) || isNaN(end_time)
    delta = (end_time - start_time) / 60000
    start_time = start_time.getHours() * 60 + start_time.getMinutes()
    end_time = start_time + delta

    # tranh truong hop ko co kinmu_type
    if kinmu_type == "" || kinmu_type == null
      kinmu_type = '000'

    # quy doi thoi gian chuan cua kinmu_type ra phut
    kinmu_start = KINMU[kinmu_type].s * 60
    kinmu_end = KINMU[kinmu_type].e * 60

    switch kinmu_type
      when '000'
        results = kyuukei_time_calculate(start_time, end_time)
        [results.fustu_zangyo, results.shinya_zangyou] = zangyou_time_calculate(start_time, end_time)
      else # Kinmu_type '001' ->'011'
        if start_time <= kinmu_start
          if kinmu_start < end_time # se bat dau dem tu kinmu_start
            results = kyuukei_time_calculate(kinmu_start, end_time)
            if end_time < kinmu_end # dem den end_time
              # start_time <= kinmu_start < end_time < kinmu_end
              results.chikoku_soutai += kinmu_end - end_time # tinh thoi gian ve som             
            else # if end_time >= kinmu_end
              # start_time <= kinmu_start < kinmu_end <= end_time
              [results.fustu_zangyo, results.shinya_zangyou] = zangyou_time_calculate(kinmu_end, end_time)
          else # if kinmu_start >= end_time
            # nothing to do
        else # if start_time > kinmu_start thi se dem tu start_time, chikoku > 0          
          if start_time < kinmu_end
            if kinmu_end <= end_time # dem den kinmu_end
              # kinmu_start < start_time < kinmu_end <= end_time
              results = kyuukei_time_calculate(start_time, kinmu_end)
              results.chikoku_soutai += start_time - kinmu_start # tinh thoi gian di muon
            else # if kinmu_end > end_time thi dem den end_time
              # kinmu_start < start_time < end_time < kinmu_end
              results = kyuukei_time_calculate(start_time, end_time)
              results.chikoku_soutai += start_time - kinmu_start + kinmu_end - end_time
          else # if start_time >= kinmu_end
            # nothing to do
    results.chikoku_soutai = Math.ceil(results.chikoku_soutai / 30) * 0.5
    results.real_hours -= results.fustu_zangyo + results.shinya_zangyou
    return results