jQuery ->
  oTable = $('.mybashotable').DataTable({
    "dom": 'lBfrtip',
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "aoColumnDefs": [ 
      { "bSortable": false, "aTargets": [ 8,9 ]},
      {
        "targets": [8,9],
        "width": '5%'
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
                  $("#edit_mybasho").attr("disabled", true);
                  $("#destroy_mybasho").attr("disabled", true);
                else
                  $("#destroy_mybasho").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_mybasho").attr("disabled", false);
                  else
                    $("#edit_mybasho").attr("disabled", true);
                $(".buttons-select-none").removeClass('disabled')




            },
            {
              "extend": 'selectNone',
              "action": ( e, dt, node, config ) ->
                oTable.$('tr').removeClass('selected')
                oTable.$('tr').removeClass('success')
                selects = oTable.rows('tr.selected').data()
                if selects.length == 0
                  $("#edit_mybasho").attr("disabled", true);
                  $("#destroy_mybasho").attr("disabled", true);
                else
                  $("#destroy_mybasho").attr("disabled", false);
                  if selects.length == 1
                    $("#edit_mybasho").attr("disabled", false);
                  else
                    $("#edit_mybasho").attr("disabled", true);
                $(".buttons-select-none").addClass('disabled')
            }

            ]
  })

  $("#edit_mybasho").attr("disabled", true);
  $("#destroy_mybasho").attr("disabled", true);


  $(document).bind('ajaxError', 'form#new_mybashomaster', (event, jqxhr, settings, exception) ->
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


  $('.mybashotable').on( 'click', 'tr',  () ->
    d = oTable.row(this).data()
    if d != undefined
      if $(this).hasClass('selected')
        $(this).removeClass('selected')
        $(this).removeClass('success')
        # $("#edit_mybasho").attr("disabled", true);
        # $("#destroy_mybasho").attr("disabled", true);
      else
        # oTable.$('tr.selected').removeClass('selected')
        # oTable.$('tr.success').removeClass('success')
        $(this).addClass('selected')
        $(this).addClass('success')        
        #$("#edit_mybasho").attr("disabled", true);
        # $("#edit_mybasho").attr("disabled", false);
        # $("#destroy_mybasho").attr("disabled", false);
    selects = oTable.rows('tr.selected').data()
    if selects.length == 0
      $("#edit_mybasho").attr("disabled", true);
      $("#destroy_mybasho").attr("disabled", true);
      $(".buttons-select-none").addClass('disabled')
    else
      $("#destroy_mybasho").attr("disabled", false);
      $(".buttons-select-none").removeClass('disabled')
      if selects.length == 1
        $("#edit_mybasho").attr("disabled", false);
      else
        $("#edit_mybasho").attr("disabled", true);

  )

  $('#destroy_mybasho').click () ->
    mybashos = oTable.rows('tr.selected').data()    
    mybashoIds = new Array();
    if mybashos.length == 0
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
        len = mybashos.length
        for i in [0...len]          
          mybashoIds[i] = mybashos[i][8].split('/')[2]

        $.ajax({
          url: '/mybashomasters/ajax',
          data:{
            focus_field: 'mybasho_削除する',
            mybashos: mybashoIds
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
            console.log("mybasho_削除する keydown Unsuccessful")

        })
        $("#edit_mybasho").attr("disabled", true);
        $("#destroy_mybasho").attr("disabled", true);

      ,(dismiss) ->
        if dismiss == 'cancel'

          selects = oTable.rows('tr.selected').data()
          if selects.length == 0
            $("#edit_mybasho").attr("disabled", true);
            $("#destroy_mybasho").attr("disabled", true);
          else
            $("#destroy_mybasho").attr("disabled", false);
            if selects.length == 1
              $("#edit_mybasho").attr("disabled", false);
            else
              $("#edit_mybasho").attr("disabled", true);
      ); 
  $('#edit_mybasho').click ->      
    new_address = oTable.row('tr.selected').data()[8].split("\"")[1]    
    if new_address == undefined
      swal("行を選択してください。")
    else            
      window.location = new_address