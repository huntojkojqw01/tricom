// init search table
$(function() {
    oTable = $('#kaishamaster-table').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
        ,
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]
        ,"oSearch": {"sSearch": queryParameters().search}
    });
    $('#kaishamaster-table').on( 'click', 'tr', function () {

        var d = oTable.row(this).data();
        if(d != undefined){
            if($(this).hasClass('selected')){
                $(this).removeClass('selected');
                $(this).removeClass('success');
                $("#edit_kaisha").attr("disabled", true);
                $("#destroy_kaisha").attr("disabled", true);
            }else{
                oTable.$('tr.selected').removeClass('selected');
                oTable.$('tr.success').removeClass('success');
                $(this).addClass('selected');
                $(this).addClass('success');
                $("#edit_kaisha").attr("disabled", false);
                $("#destroy_kaisha").attr("disabled", false);
            }
        }
    });
});


$(document).ready(function(){
    $("#edit_kaisha").attr("disabled", true);
    $("#destroy_kaisha").attr("disabled", true);
    $(document).bind('ajaxError', 'form#new_kaishamaster', function(event, jqxhr, settings, exception){
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

    $('#destroy_kaisha').click(function(){
        var kaisha = oTable.row('tr.selected').data()
        if( kaisha == undefined)
            swal($('#message_confirm_select').text())
        else{
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
            }).then(function() {
                $.ajax({
                    url: '/kaishamasters/ajax',
                    data:{
                        focus_field: 'kaisha_削除する',
                        kaisha_id: kaisha[0]
                    },

                    type: "POST",

                    success: function(data){
                        swal("削除されました!", "", "success");
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          $("#kaishamaster-table").dataTable().fnDeleteRow($('#kaishamaster-table').find('tr.selected').remove());
                          $("#kaishamaster-table").dataTable().fnDraw();

                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("kaisha_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_kaisha").attr("disabled", true);
                $("#destroy_kaisha").attr("disabled", true);
            },function(dismiss) {
                if (dismiss === 'cancel') {
                    $("#edit_kaisha").attr("disabled", false)
                    $("#destroy_kaisha").attr("disabled", false)
                }
            });
            // var response = confirm($('#message_confirm_delete').text());
            // if (response){
            //     $.ajax({
            //         url: '/kaishamasters/ajax',
            //         data:{
            //             focus_field: 'kaisha_削除する',
            //             kaisha_id: kaisha[0]
            //         },

            //         type: "POST",

            //         success: function(data){
            //             if (data.destroy_success != null){
            //               console.log("getAjax destroy_success:"+ data.destroy_success);
            //               $("#kaishamaster-table").dataTable().fnDeleteRow($('#kaishamaster-table').find('tr.selected').remove());
            //               $("#kaishamaster-table").dataTable().fnDraw();

            //             }else
            //               console.log("getAjax destroy_success:"+ data.destroy_success);
            //          },
            //          failure: function(){
            //             console.log("kaisha_削除する keydown Unsuccessful");
            //          }


            //     });
            //     $("#edit_kaisha").attr("disabled", true);
            //     $("#destroy_kaisha").attr("disabled", true);

            // }else{
            //     $("#edit_kaisha").attr("disabled", false)
            //     $("#destroy_kaisha").attr("disabled", false)
            // }

        }
    });



    $('#new_kaisha').click(function(){
        $('#kaisha-new-modal').modal('show');

        //$('#jpt_holiday_mst_id').val('');
        $('#kaishamaster_会社コード').val('');
        $('#kaishamaster_会社名').val('');
        $('#kaishamaster_備考').val('');
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_kaisha').click(function(){
        var kaisha = oTable.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (kaisha == undefined)
            swal("行を選択してください。");
        else{
            $('#kaisha-edit-modal').modal('show');
            $('#kaishamaster_会社コード').val(kaisha[0]);
            $('#kaishamaster_会社名').val(kaisha[1]);
            $('#kaishamaster_備考').val(kaisha[2]);


        }

    });



});
