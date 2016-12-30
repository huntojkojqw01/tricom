// init search table
$(function() {
    oTable = $('#shozokumaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        },
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]

    });
    $('#shozokumaster').on( 'click', 'tr', function () {

        var d = oTable.row(this).data();
        if(d != undefined){
            if($(this).hasClass('selected')){
                $(this).removeClass('selected');
                $(this).removeClass('success');
                $("#edit_shozoku").attr("disabled", true);
                $("#destroy_shozoku").attr("disabled", true);
            }else{
                oTable.$('tr.selected').removeClass('selected');
                oTable.$('tr.success').removeClass('success');
                $(this).addClass('selected');
                $(this).addClass('success');
                $("#edit_shozoku").attr("disabled", false);
                $("#destroy_shozoku").attr("disabled", false);
            }
        }
    });
});

$(document).ready(function(){
    $("#edit_shozoku").attr("disabled", true);
    $("#destroy_shozoku").attr("disabled", true);
    $(document).bind('ajaxError', 'form#new_shozokumaster', function(event, jqxhr, settings, exception){
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

    $('#destroy_shozoku').click(function(){
        var shozoku = oTable.row('tr.selected').data()
        if( shozoku == undefined)
            alert($('#message_confirm_select').text())
        else{
            var response = confirm($('#message_confirm_delete').text());
            if (response){
                $.ajax({
                    url: '/shozokumasters/ajax',
                    data:{
                        focus_field: 'shozoku_削除する',
                        shozoku_id: shozoku[0]
                    },

                    type: "POST",

                    success: function(data){
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          $("#shozokumaster").dataTable().fnDeleteRow($('#shozokumaster').find('tr.selected').remove());
                          $("#shozokumaster").dataTable().fnDraw();

                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("shozoku_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_shozoku").attr("disabled", true);
                $("#destroy_shozoku").attr("disabled", true);

            }else{
                $("#edit_shozoku").attr("disabled", false)
                $("#destroy_shozoku").attr("disabled", false)
            }

        }
    });



    $('#new_shozoku').click(function(){
        $('#shozoku-new-modal').modal('show');

        //$('#jpt_holiday_mst_id').val('');
        $('#shozokumaster_所属コード').val('');
        $('#shozokumaster_所属名').val('');

        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_shozoku').click(function(){
        var shozoku = oTable.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (shozoku == undefined)
          alert("行を選択してください。");
        else{
            $('#shozoku-edit-modal').modal('show');
            $('#shozokumaster_所属コード').val(shozoku[0]);
            $('#shozokumaster_所属名').val(shozoku[1]);



        }

    });



});
