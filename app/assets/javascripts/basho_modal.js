$(document).ready(function(){
    $("#edit_basho").addClass("disabled");
    $("#destroy_basho").addClass("disabled");
    oBashoTable = $('#basho_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });

    $(document).bind('ajaxError', 'form#new_bashomaster', function(event, jqxhr, settings, exception){
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


$(function () {
    $('.search-field').click( function(){
        var element1 = $('.search-group').find('#bashomaster_会社コード')
        if( $(this).prev().is(element1)){
            $('#kaisha-search-modal').modal('show');
            var kaisha_code = $(this).prev().val();
            if(kaisha_code != ''){
                oKaisha_modal.rows().every( function( rowIdx, tableLoop, rowLoop ){
                  var data = this.data();
                  if( data[0] == kaisha_code){
                    oKaisha_modal.$('tr.selected').removeClass('selected');
                    oKaisha_modal.$('tr.success').removeClass('success');
                    this.nodes().to$().addClass('selected')
                    this.nodes().to$().addClass('success')
                  }
                });
                var check_select = oKaisha_modal.rows('tr.selected').data();
                if(check_select == undefined){
                  $("#edit_kaishamaster").addClass("disabled");
                  $("#destroy_kaishamaster").addClass("disabled");
                }else{
                  $("#edit_kaishamaster").removeClass("disabled");
                  $("#destroy_kaishamaster").removeClass("disabled");
                }
                oKaisha_modal.page.jumpToData(kaisha_code, 0);
              }
        }
    })
    $('.search-plus').click( function(){
      var element1 = $('.search-group').find('#bashomaster_会社コード')
      if( $(this).prev().prev().is(element1)){
        $('#kaisha-new-modal').modal('show')
        $('#kaisha-new-modal #kaishamaster_会社コード').val('');
        $('#kaisha-new-modal #kaishamaster_会社名').val('');
        $('#kaisha-new-modal #kaishamaster_備考').val('');
      }

    })
    //場所選択された行を判断
    $('#basho_table tbody').on( 'click', 'tr', function () {

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $("#edit_basho").addClass("disabled");
            $("#destroy_basho").addClass("disabled");
        }
        else {
            oBashoTable.$('tr.selected').removeClass('selected');
            oBashoTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $("#edit_basho").removeClass("disabled");
            $("#destroy_basho").removeClass("disabled");
        }
    } );
    $('#clear_basho').click(function () {

        oBashoTable.$('tr.selected').removeClass('selected');
        oBashoTable.$('tr.success').removeClass('success');
        $("#edit_basho").addClass("disabled");
        $("#destroy_basho").addClass("disabled");
    });

    $('#basho_table tbody').on( 'dblclick', 'tr', function () {
        $(this).addClass('selected');
        $(this).addClass('success');
        var mybasho = oBashoTable.row('tr.selected').data();
        var shain = $('#event_社員番号').val();
        $.ajax({
            url: '/events/ajax',
            data: {id: 'basho_selected',mybasho_id: mybasho[0],shain: shain},
            type: "POST",

            success: function(data) {
               if(data.mybasho_id != null){
                    console.log("getAjax mybasho_id:"+ data.mybasho_id);

                }
                else{

                    console.log("getAjax mybasho_id:"+ data.mybasho_id);
                }
            },
            failure: function() {
                console.log("basho_selected keydown Unsuccessful");
            }
        });
        if(mybasho!= undefined){
            $('#event_場所コード').val(mybasho[0]);
            $('.hint-basho-refer').text(mybasho[1]);
            $('#event_場所コード').closest('.form-group').find('span.help-block').remove();
            $('#event_場所コード').closest('.form-group').removeClass('has-error')
        }
        $('#basho_search_modal').modal('hide')
    } );
    $('#basho_sentaku_ok').click(function(){

        var mybasho = oBashoTable.row('tr.selected').data();
        var shain = $('#event_社員番号').val();
        $.ajax({
            url: '/events/ajax',
            data: {id: 'basho_selected',mybasho_id: mybasho[0],shain: shain},
            type: "POST",

            success: function(data) {
               if(data.mybasho_id != null){
                    console.log("getAjax mybasho_id:"+ data.mybasho_id);

                }
                else{

                    console.log("getAjax mybasho_id:"+ data.mybasho_id);
                }
            },
            failure: function() {
                console.log("basho_selected keydown Unsuccessful");
            }
        });
        if(mybasho!= undefined){
            $('#event_場所コード').val(mybasho[0]);
            $('.hint-basho-refer').text(mybasho[1]);
            $('#event_場所コード').closest('.form-group').find('span.help-block').remove();
            $('#event_場所コード').closest('.form-group').removeClass('has-error')

        }
    });

});


$(function() {

    $('#destroy_basho').click(function(){
        var bashomaster = oBashoTable.rows('tr.selected').data()
        var bashoIds = new Array();
        if( bashomaster == undefined)
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
                for (var i = 0; i < bashomaster.length; i++) {
                  bashoIds[i] = bashomaster[i][0]
                }

                $.ajax({
                    url: '/bashomasters/ajax',
                    data:{
                        focus_field: 'basho_削除する',
                        bashos: bashoIds
                    },

                    type: "POST",

                    success: function(data){
                        swal("削除されました!", "", "success");
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          var d = oBashoTable.row('tr.selected').data();
                          oBashoTable.rows('tr.selected').remove().draw();
                          if(d[0]==$('#event_場所コード').val()){
                            $('#event_場所コード').val('');
                            $('.hint-basho-refer').text('');
                          }
                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("basho_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_basho").addClass("disabled");
                $("#destroy_basho").addClass("disabled");
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    $("#edit_basho").attr("disabled", false)
                    $("#destroy_basho").attr("disabled", false)
                }
            });
        }
    });



    $('#new_basho').click(function(){
        $('#basho-new-modal').modal('show');

        $('#basho-new-modal #bashomaster_場所コード').val('');
        $('#basho-new-modal #bashomaster_場所名').val('');
        $('#basho-new-modal #bashomaster_場所名カナ').val('');
        $('#basho-new-modal #bashomaster_SUB').val('');
        $('#basho-new-modal #bashomaster_場所区分').val('');
        $('#basho-new-modal #bashomaster_会社コード').val('');

        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_basho').click(function(){
        var bashomaster = oBashoTable.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (bashomaster == undefined)
          swal("行を選択してください。");
        else{
            jQuery.ajax({
                url: '/events/ajax',
                data: {id: 'get_basho_selected',basho_id: bashomaster[0]},
                type: "POST",
                success: function(data) {
                  $('#basho-edit-modal').modal('show');
                  $('#basho-edit-modal #bashomaster_場所コード').val(data.basho.場所コード);
                  $('#basho-edit-modal #bashomaster_場所名').val(data.basho.場所名);
                  $('#basho-edit-modal #bashomaster_場所名カナ').val(data.basho.場所名カナ);
                  $('#basho-edit-modal #bashomaster_SUB').val(data.basho.SUB);
                  $('#basho-edit-modal #bashomaster_場所区分').val(data.basho.場所区分);
                  $('#basho-edit-modal #bashomaster_会社コード').val(data.basho.会社コード);
                },
                failure: function() {
                    console.log("Unsuccessful");
                }
            });

        }

    });



});
