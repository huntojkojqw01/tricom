$(document).ready(function(){
    $("#edit_joutaimaster").attr("disabled", true);
    $("#destroy_joutaimaster").attr("disabled", true);
    oJoutaiTable = $('#joutai_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });

    $(document).bind('ajaxError', 'form#new_joutaimaster', function(event, jqxhr, settings, exception){
        $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
    });

});
//colorpicker
$(function(){
    $('#joutai-new-modal #joutaimaster_色').colorpicker();
    $('#joutai-new-modal #joutaimaster_text_color').colorpicker();

    $('#joutai-new-modal #joutaimaster_色').colorpicker().on('changeColor', function(ev){
        $('#joutai-new-modal #preview-backgroud').css("background-color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

    $('#joutai-new-modal #joutaimaster_text_color').colorpicker().on('changeColor', function(ev){
        $('#joutai-new-modal #preview-text').css("color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });


    $('#joutai-edit-modal #joutaimaster_色').colorpicker();
    $('#joutai-edit-modal #joutaimaster_text_color').colorpicker();

    $('#joutai-edit-modal #joutaimaster_色').colorpicker().on('changeColor', function(ev){
        $('#joutai-edit-modal #preview-backgroud').css("background-color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

    $('#joutai-edit-modal #joutaimaster_text_color').colorpicker().on('changeColor', function(ev){
        $('#joutai-edit-modal #preview-text').css("color", ev.color.toHex());
        $(this).val(ev.color.toHex());
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


$(function () {

    //状態選択された行を判断
    $('#joutai_table tbody').on( 'click', 'tr', function () {

        var d = oJoutaiTable.row(this).data();
        $('#event_状態コード').val(d[0]);
        $('.hint-joutai-refer').text(d[1]);
        if( d[1] == '外出' || d[1] == '直行' || d[1] == '出張' || d[1] == '出張移動')
            $('.event_帰社').show();
        else
            $('.event_帰社').hide();
        $('#event_状態コード').closest('.form-group').find('span.help-block').remove()
        $('#event_状態コード').closest('.form-group').removeClass('has-error')

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $("#edit_joutaimaster").attr("disabled", true);
            $("#destroy_joutaimaster").attr("disabled", true);
        }
        else {
            oJoutaiTable.$('tr.selected').removeClass('selected');
            oJoutaiTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $("#edit_joutaimaster").attr("disabled", false);
            $("#destroy_joutaimaster").attr("disabled", false);
        }
        //check if that day missing
        var strtime = new Date($("#event_開始").val());
        if (d[0] == "30" || (d[0] == "60" && strtime.getHours() >= 9)){
            //$('#event_開始').val(moment());
            //$('#event_終了').val(moment());

            $('#event_場所コード').prop( "disabled", true );
            $('#event_JOB').prop( "disabled", true );
            $('#event_工程コード').prop( "disabled", true );
            $('#basho_search').prop( "disabled", true );
            $('#koutei_search').prop( "disabled", true );

        }else{
            //$('#event_開始').val('');
            //$('#event_終了').val('');

            $('#event_場所コード').prop( "disabled", false );
            $('#event_JOB').prop( "disabled", false );
            $('#event_工程コード').prop( "disabled", false );
            $('#basho_search').prop( "disabled", false );
            $('#koutei_search').prop( "disabled", false );

        }


    } );
    $('#clear_joutai').click(function () {
        $('.event_帰社').hide();

        $('#event_状態コード').val('');
        $('.hint-joutai-refer').text('');
        $('#event_状態コード').closest('.form-group').find('span.help-block').remove();
        $('#event_状態コード').closest('.form-group').removeClass('has-error');
        oJoutaiTable.$('tr.selected').removeClass('selected');
        oJoutaiTable.$('tr.success').removeClass('success');
        $('#event_場所コード').prop( "disabled", false );
        $('#event_JOB').prop( "disabled", false );
        $('#event_工程コード').prop( "disabled", false );
        $('#basho_search').prop( "disabled", false );
        $('#koutei_search').prop( "disabled", false );
        $("#edit_joutaimaster").attr("disabled", true);
        $("#destroy_joutaimaster").attr("disabled", true);

    });

});


$(function() {

    $('#destroy_joutaimaster').click(function(){
        var joutaimaster = oJoutaiTable.rows('tr.selected').data()
        var joutaiIds = new Array();
        if( joutaimaster == undefined)
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
                for (var i = 0; i < joutaimaster.length; i++) {
                  joutaiIds[i] = joutaimaster[i][0]
                }

                $.ajax({
                    url: '/joutaimasters/ajax',
                    data:{
                        focus_field: 'joutaimaster_削除する',
                        joutais: joutaiIds
                    },

                    type: "POST",

                    success: function(data){
                        swal("削除されました!", "", "success");
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          oJoutaiTable.rows('tr.selected').remove().draw();
                          $('.event_帰社').hide();
                          $('#event_状態コード').val('');
                          $('.hint-joutai-refer').text('');
                          $("#edit_joutaimaster").attr("disabled", true);
                          $("#destroy_joutaimaster").attr("disabled", true);
                          $('#event_場所コード').prop( "disabled", false );
                          $('#event_JOB').prop( "disabled", false );
                          $('#event_工程コード').prop( "disabled", false );
                          $('#basho_search').prop( "disabled", false );
                          $('#koutei_search').prop( "disabled", false );
                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("joutai_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_joutaimaster").attr("disabled", true);
                $("#destroy_joutaimaster").attr("disabled", true);
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    $("#edit_joutaimaster").attr("disabled", false)
                    $("#destroy_joutaimaster").attr("disabled", false)
                }
            });
        }
    });



    $('#new_joutaimaster').click(function(){
        $('#joutai-new-modal').modal('show');

        $('#joutai-new-modal #joutaimaster_状態コード').val('');
        $('#joutai-new-modal #joutaimaster_状態名').val('');
        $('#joutai-new-modal #joutaimaster_状態区分').val('');
        $('#joutai-new-modal #joutaimaster_勤怠状態名').val('');
        $('#joutai-new-modal #joutaimaster_マーク').val('');
        $('#joutai-new-modal #joutaimaster_色').val('');
        $('#joutai-new-modal #joutaimaster_text_color').val('');
        $('#joutai-new-modal #joutaimaster_WEB使用区分').val('');
        $('#joutai-new-modal #joutaimaster_勤怠使用区分').val('');
        $("#joutai-new-modal #preview-text").css('color', 'black');
        $('#joutai-new-modal #preview-backgroud').css("background-color", 'white');

        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_joutaimaster').click(function(){
        var joutaimaster = oJoutaiTable.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (joutaimaster == undefined)
          swal("行を選択してください。");
        else{
            alert(joutaimaster[0])
            jQuery.ajax({
                url: '/joutaimasters/ajax',
                data: {focus_field: 'get_joutai_selected',joutai_id: joutaimaster[0]},
                type: "POST",
                success: function(data) {
                  $('#joutai-edit-modal').modal('show');
                  $('#joutai-edit-modal #joutaimaster_状態コード').val(data.joutai.状態コード);
                  $('#joutai-edit-modal #joutaimaster_状態名').val(data.joutai.状態名);
                  $('#joutai-edit-modal #joutaimaster_状態区分').val(data.joutai.状態区分);
                  $('#joutai-edit-modal #joutaimaster_勤怠状態名').val(data.joutai.勤怠状態名);
                  $('#joutai-edit-modal #joutaimaster_マーク').val(data.joutai.マーク);
                  $('#joutai-edit-modal #joutaimaster_色').val(data.joutai.色);
                  $('#joutai-edit-modal #joutaimaster_text_color').val(data.joutai.文字色);
                  $('#joutai-edit-modal #joutaimaster_WEB使用区分').val(data.joutai.WEB使用区分);
                  $('#joutai-edit-modal #joutaimaster_勤怠使用区分').val(data.joutai.勤怠使用区分);
                  $("#joutai-edit-modal #preview-text").css('color', data.joutai.文字色);
                  $('#joutai-edit-modal #preview-backgroud').css("background-color", data.joutai.色);
                },
                failure: function() {
                    console.log("Unsuccessful");
                }
            });

        }

    });



});
