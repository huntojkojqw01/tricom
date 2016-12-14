//$(document).ready(function(){
$(function(){

    oTable = $('#kouteimaster').DataTable({
        "pagingType": "full_numbers",
        //"scrollX": true,
        //"scrollCollapse": true,
        "oLanguage":{
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        },
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 3,4 ]},
            {
                "targets": [3,4],
                "width": '5%'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]

    });

    //選択された行を判断
    $('#kouteimaster tbody').on( 'click', 'tr', function () {

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
        }
        else {
            oTable.$('tr.selected').removeClass('selected');
            oTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );
});


/**
 * Created by cmc on 1/26/15.
 */

//for handle ajax error
$(function () {
    $(document).bind('ajaxError', 'form#new_kouteimaster', function (event, jqxhr, settings, exception) {
        // note: jqxhr.responseJSON undefined, parsing responseText instead
        $(event.data).render_form_errors($.parseJSON(jqxhr.responseText));
    });

    //$(document).bind('ajaxSuccess', 'form#new_kouteimaster', function (event, jqxhr, settings, exception) {
    //    // note: jqxhr.responseJSON undefined, parsing responseText instead
    //    $(location).attr('href','/kouteimasters');
    //});
});

//defind ref functions
(function($) {

    $.fn.modal_success = function(){
        // close modal
        this.modal('hide');

        // clear form input elements
        // note: handle textarea, select, etc
        this.find('form input[type="text"]').val('');

        // clear error state
        this.clear_previous_errors();
    };

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

//button handle
$(function(){
    $('#shozoku_search').click(function(){
        $('#select_shozoku_modal').modal('show');
    });

});

//keydown trigger
$(function(){
    //var url_path = $(location).attr('pathname');
    $('#kouteimaster_所属コード').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var kouteimaster_shozoku_code = $('#kouteimaster_所属コード').val();
            jQuery.ajax({
                url: '/kouteimasters/ajax',
                data: {id: 'kouteimaster_所属コード',kouteimaster_shozoku_code: kouteimaster_shozoku_code},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    $('#shozoku_name').text(data.shozoku_name);
                    console.log("getAjax kouteimaster_所属コード:"+ data.shozoku_name);
                },
                failure: function() {
                    console.log("kouteimaster_所属コード keydown Unsuccessful");
                }
            });
        }
    });
});

//Add maxlength display
//$(function(){
//    $('input[maxlength]').maxlength();
//
//});