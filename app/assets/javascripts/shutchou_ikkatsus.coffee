jQuery ->
  kousu = []
  countup = 0
  until countup > 1000
    kousu.push(countup)
    countup += 0.25

  $('#koushuu').click (event) ->
    start_time = $('#event_開始').val()
    end_time = $('#event_終了').val()
    event1_start = $('#event1_start').val();
    event1_end = $('#event1_end').val();
    event3_start = $('#event3_start').val();
    event3_end = $('#event3_end').val();

    diff = moment(end_time,'YYYY/MM/DD HH:mm').diff(moment(start_time,'YYYY/MM/DD HH:mm'),'hours', true)
    if diff > 0
      for num in kousu
        if num > diff && num > 0
          $('#event_工数').val(num-0.25)
          break
    else
      $('#event_工数').val(0);

    diff = moment(event1_end,'YYYY/MM/DD HH:mm').diff(moment(event1_start,'YYYY/MM/DD HH:mm'),'hours', true)
    if diff > 0
      for num in kousu
        if num > diff && num > 0
          $('#event1_koushuu').val(num-0.25)
          break
    else
      $('#event1_koushuu').val(0);

    diff = moment(event3_end,'YYYY/MM/DD HH:mm').diff(moment(event3_start,'YYYY/MM/DD HH:mm'),'hours', true)
    if diff > 0
      for num in kousu
        if num > diff && num > 0
          $('#event3_koushuu').val(num-0.25)
          break
    else
      $('#event3_koushuu').val(0);

  $('.search-field').click( () ->
    element1 = $('.search-group').find('#event_状態コード')
    element2 = $('.search-group').find('#event_場所コード')
    element3 = $('.search-group').find('#event_JOB')
    element4 = $('.search-group').find('#event_工程コード')
    element5 = $('.search-group').find('#mybashomaster_会社コード')

    if $(this).prev().is(element1)
      $('#joutai_search_modal').modal('show')
      if $('#event_状態コード').val() != ''
        oJoutaiTable.rows().every( ( rowIdx, tableLoop, rowLoop ) ->
          data = this.data();
          if data[0] == $('#event_状態コード').val()
            oJoutaiTable.$('tr.selected').removeClass('selected');
            oJoutaiTable.$('tr.success').removeClass('success');
            this.nodes().to$().addClass('selected')
            this.nodes().to$().addClass('success')
        );
        check_select = oJoutaiTable.rows('tr.selected').data();
        if check_select == undefined
          $("#edit_joutaimaster").attr("disabled", true);
          $("#destroy_joutaimaster").attr("disabled", true);
        else
          $("#edit_joutaimaster").attr("disabled", false);
          $("#destroy_joutaimaster").attr("disabled", false);
        oJoutaiTable.page.jumpToData($('#event_状態コード').val(), 0);

    if $(this).prev().is(element2)
      $('#basho_search_modal').modal('show')
      if $('#event_場所コード').val() != ''
        oBashoTable.rows().every( ( rowIdx, tableLoop, rowLoop ) ->
          data = this.data();
          if data[0] == $('#event_場所コード').val()
            oBashoTable.$('tr.selected').removeClass('selected');
            oBashoTable.$('tr.success').removeClass('success');
            this.nodes().to$().addClass('selected')
            this.nodes().to$().addClass('success')
        );
        check_select = oBashoTable.rows('tr.selected').data();
        if check_select == undefined
          $("#edit_basho").attr("disabled", true);
          $("#destroy_basho").attr("disabled", true);
        else
          $("#edit_basho").attr("disabled", false);
          $("#destroy_basho").attr("disabled", false);
        oBashoTable.page.jumpToData($('#event_場所コード').val(), 0);

    if $(this).prev().is(element3)
      $('#job_search_modal').modal('show')
      if $('#event_JOB').val() != ''
        oJobTable.rows().every( ( rowIdx, tableLoop, rowLoop ) ->
          data = this.data();
          if data[0] == $('#event_JOB').val()
            oJobTable.$('tr.selected').removeClass('selected');
            oJobTable.$('tr.success').removeClass('success');
            this.nodes().to$().addClass('selected')
            this.nodes().to$().addClass('success')
        );
        check_select = oJobTable.rows('tr.selected').data();
        if check_select == undefined
          $("#edit_jobmaster").attr("disabled", true);
          $("#destroy_jobmaster").attr("disabled", true);
        else
          $("#edit_jobmaster").attr("disabled", false);
          $("#destroy_jobmaster").attr("disabled", false);
        oJobTable.page.jumpToData($('#event_JOB').val(), 0);

    if $(this).prev().is(element4)
      $('#koutei_search_modal').modal('show')

    if $(this).prev().is(element5)
      $('#kaisha-search-modal').modal('show')
  )

  $('.search-history').click( () ->
    element1 = $('.search-group').find('#event_場所コード')
    element2 = $('.search-group').find('#event_JOB')
    if $(this).prev().prev().is(element1)
      $('#mybasho_search_modal').modal('show')
      mybasho = oMybashoTable.row('tr.selected').data();
      if mybasho == undefined
        $("#mybasho_destroy").attr("disabled", true);
      else
        $("#mybasho_destroy").attr("disabled", false);
    if $(this).prev().prev().is(element2)
      $('#myjob_search_modal').modal('show')
      myjob = oMyjobTable.row('tr.selected').data();
      if myjob == undefined
        $("#myjob_destroy").attr("disabled", true);
      else
        $("#myjob_destroy").attr("disabled", false);
  )
