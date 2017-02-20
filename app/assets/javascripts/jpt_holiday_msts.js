// init search table
$(function() {
    oTable = $('#holiday_table').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
        ,
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        },
        {
            "targets": [ 0 ],
            "visible": false
        }
        ]
    });

    $('#holiday_table').on( 'click', 'tr', function () {

        var d = oTable.row(this).data();
        if(d != undefined){
            if($(this).hasClass('selected')){
                $(this).removeClass('selected');
                $(this).removeClass('success');
                $("#edit_holiday").attr("disabled", true);
                $("#destroy_holiday").attr("disabled", true);
            }else{
                oTable.$('tr.selected').removeClass('selected');
                oTable.$('tr.success').removeClass('success');
                $(this).addClass('selected');
                $(this).addClass('success');
                $("#edit_holiday").attr("disabled", false);
                $("#destroy_holiday").attr("disabled", false);
            }
        }
    });


});
$(document).ready(function(){
    $("#edit_holiday").attr("disabled", true);
    $("#destroy_holiday").attr("disabled", true);
    $(document).bind('ajaxError', 'form#new_jpt_holiday_mst', function(event, jqxhr, settings, exception){
        $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
    });
});


(function($) {

  $.fn.render_form_errors = function(errors){

    $form = this;
    this.clear_previous_errors();
    model = this.data('model');

    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    });

  };

  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  }

}(jQuery));



$(function() {

    $('#destroy_holiday').click(function(){
        var holiday = oTable.row('tr.selected').data()
        if( holiday == undefined)
            swal($('#message_confirm_select').text())
        else{
            swal({
                title: $('#message_confirm_delete').text(),
                text: "",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "OK",
                cancelButtonText: "Cancel",
                closeOnConfirm: false,
                closeOnCancel: false
            }).then(function() {
                $.ajax({
                    url: '/jpt_holiday_msts/ajax',
                    data:{
                        focus_field: 'holiday_削除する',
                        holiday_id: holiday[0]
                    },

                    type: "POST",

                    success: function(data){
                        swal("削除されました!", "", "success");
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          $("#holiday_table").dataTable().fnDeleteRow($('#holiday_table').find('tr.selected').remove());
                          $("#holiday_table").dataTable().fnDraw();

                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("holiday_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_holiday").attr("disabled", true);
                $("#destroy_holiday").attr("disabled", true);
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    $("#edit_holiday").attr("disabled", false)
                    $("#destroy_holiday").attr("disabled", false)
                }
            });
            // var response = confirm($('#message_confirm_delete').text());
            // if (response){
            //     $.ajax({
            //         url: '/jpt_holiday_msts/ajax',
            //         data:{
            //             focus_field: 'holiday_削除する',
            //             holiday_id: holiday[0]
            //         },

            //         type: "POST",

            //         success: function(data){
            //             if (data.destroy_success != null){
            //               console.log("getAjax destroy_success:"+ data.destroy_success);
            //               $("#holiday_table").dataTable().fnDeleteRow($('#holiday_table').find('tr.selected').remove());
            //               $("#holiday_table").dataTable().fnDraw();

            //             }else
            //               console.log("getAjax destroy_success:"+ data.destroy_success);
            //          },
            //          failure: function(){
            //             console.log("holiday_削除する keydown Unsuccessful");
            //          }


            //     });
            //     $("#edit_holiday").attr("disabled", true);
            //     $("#destroy_holiday").attr("disabled", true);

            // }else{
            //     $("#edit_holiday").attr("disabled", false)
            //     $("#destroy_holiday").attr("disabled", false)
            // }

        }
    });



    $('#new_holiday').click(function(){
        $('#holiday-new-modal').modal('show');

        //$('#jpt_holiday_mst_id').val('');
        $('#holiday-new-modal #jpt_holiday_mst_event_date').val('');
        $('#holiday-new-modal #jpt_holiday_mst_title').val('');
        $('#holiday-new-modal #jpt_holiday_mst_description').val('');
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_holiday').click(function(){
        var holiday = oTable.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (holiday == undefined)
          swal("行を選択してください。");
        else{
            $('#holiday-edit-modal').modal('show');
            $('#jpt_holiday_mst_id').val(holiday[0]);
            $('#jpt_holiday_mst_event_date').val(holiday[1]);
            $('#jpt_holiday_mst_title').val(holiday[2]);
            $('#jpt_holiday_mst_description').val(holiday[3]);

        }

    });



});

//init datetimepicker
$(function(){
    $('#jpt_holiday_mst_event_date').datetimepicker({
        format: 'YYYY/MM/DD',
        widgetPositioning: {
            horizontal: 'left'
        },
        showTodayButton: true

    });
    $('#holiday-new-modal #jpt_holiday_mst_event_date').datetimepicker({
        format: 'YYYY/MM/DD',
        widgetPositioning: {
            horizontal: 'left'
        },
        showTodayButton: true

    });
});