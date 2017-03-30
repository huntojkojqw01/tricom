# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.setting-table').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    },
    "columnDefs": [ {
        "targets"  : 'no-sort',
        "orderable": false
    }],
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
                  $("#edit_setting").attr("disabled", true);
                  $("#destroy_setting").attr("disabled", true);
                else
                  $("#destroy_setting").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_setting").attr("disabled", false);
                  else
                    $("#edit_setting").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_setting").attr("disabled", true);
                  $("#destroy_setting").attr("disabled", true);
                else
                  $("#destroy_setting").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_setting").attr("disabled", false);
                  else
                    $("#edit_setting").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }
            ]

  })
  $("#edit_setting").attr("disabled", true);
  $("#destroy_setting").attr("disabled", true);

  $(document).bind('ajaxError', 'form#new_setting', (event, jqxhr, settings, exception) ->
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
  )

  $.fn.render_form_errors = (errors) ->
    $form = this;
    this.clear_previous_errors();
    model = this.data('model');


    $.each(errors, (field, messages) ->
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    );


  $.fn.clear_previous_errors = () ->
    $('.form-group.has-error', this).each( () ->
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    );
  $('.setting-table').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_setting").attr("disabled", true);
        # $("#destroy_setting").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')
        # $("#edit_setting").attr("disabled", false);
        # $("#destroy_setting").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_setting").attr("disabled", true);
      $("#destroy_setting").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_setting").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_setting").attr("disabled", false);
      else
        $("#edit_setting").attr("disabled", true);
  )

  $('#destroy_setting').click () ->
    settings = oTable.rows('tr.selected').data()
    settingIds = new Array();
    if settings.length == 0
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
        len = settings.length
        for i in [0...len]
          settingIds[i] = settings[i][0]

        $.ajax({
          url: '/settings/ajax',
          data:{
            focus_field: 'setting_削除する',
            settings: settingIds
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
            console.log("setting_削除する keydown Unsuccessful")

        })
        $("#edit_setting").attr("disabled", true);
        $("#destroy_setting").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_setting").attr("disabled", true);
            $("#destroy_setting").attr("disabled", true);
          else
            $("#destroy_setting").attr("disabled", false);
            if selects.length == 1
              $("#edit_setting").attr("disabled", false);
            else
              $("#edit_setting").attr("disabled", true);
      );
  
  $('#new_setting').click () ->
    

  $('#edit_setting').click () ->
    setting_id = oTable.row('tr.selected').data()
    window.location = '/settings/' + setting_id[0] + '/edit?'

  $('#setting_scrolltime').change ->
    scrolltime = $('#setting_scrolltime').val()
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "setting_scrolltime" ,scrolltime: scrolltime}
      success: (data) ->
        console.log 'Update setting scrolltime Successful'
      failure: () ->
        console.log 'Update setting scrolltim Unsuccessful'

  $('#setting_local').change ->
    local = $('#setting_local').val()
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "setting_local" ,local: local}
      success: (data) ->
        console.log 'Update setting local Successful'
        location.reload()
      failure: () ->
        console.log 'Update setting local Unsuccessful'


  $('#setting_select_holiday_vn').change ->
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "select_holiday_vn" ,select_holiday_vn: @checked}
      success: (data) ->
        console.log 'Update setting holiday_vn Successful'
      failure: () ->
        console.log 'Update setting holiday_vn Unsuccessful'

  $('#setting_turning_data').change ->
    $.ajax
      type: 'POST'
      url: '/settings/ajax'
      data: {setting: "turning_data" ,turning_data: @checked}
      success: (data) ->
        console.log 'Update setting turning data Successful'
      failure: () ->
        console.log 'Update setting turning data Unsuccessful'
