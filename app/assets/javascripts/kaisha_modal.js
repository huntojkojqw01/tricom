$(document).ready(function(){
    $("#edit_kaishamaster").addClass("disabled");
    $("#destroy_kaishamaster").addClass("disabled");
    oKaisha_modal = $('#kaisha-table-modal').DataTable({
      "pagingType": "simple_numbers"
      ,"oLanguage":{
        "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
      }
    })
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

$(function () {

  $('#kaisha-table-modal tbody').on( 'click', 'tr', function () {

    if( $(this).hasClass('selected')){
      $(this).removeClass('selected');
      $(this).removeClass('success');
      $("#edit_kaishamaster").addClass("disabled");
      $("#destroy_kaishamaster").addClass("disabled");
    }else{
      oKaisha_modal.$('tr.selected').removeClass('selected');
      oKaisha_modal.$('tr.success').removeClass('success');
      $(this).addClass('selected');
      $(this).addClass('success');
      $("#edit_kaishamaster").removeClass("disabled");
      $("#destroy_kaishamaster").removeClass("disabled");
    }

  });

  $('#clear_kaisha').click(function () {

        oKaisha_modal.$('tr.selected').removeClass('selected');
        oKaisha_modal.$('tr.success').removeClass('success');
        $("#edit_kaishamaster").addClass("disabled");
        $("#destroy_kaishamaster").addClass("disabled");
    });
  $('#kaisha_sentaku_ok').click(function(){
    var kaisha = oKaisha_modal.row('tr.selected').data();
    if(kaisha!= undefined){
      $('#jobmaster_ユーザ番号').val(kaisha[0]);
        $('#jobmaster_ユーザ名').val(kaisha[1]);
        $('#jobmaster_ユーザ番号').closest('.form-group').find('.span.help-block').text('');
        $('#jobmaster_ユーザ番号').closest('.form-group').removeClass('has-error');

        $('#bashomaster_会社コード').val(kaisha[0]);
        $('#bashomaster_会社コード').closest('.form-group').find('.span.help-block').text('');
        $('#bashomaster_会社コード').closest('.form-group').removeClass('has-error');
    }
  })

  $('#kaisha-table-modal tbody').on( 'dblclick', 'tr', function () {
    $(this).addClass('selected');
    $(this).addClass('success');
    var kaisha = oKaisha_modal.row('tr.selected').data();
    if(kaisha!= undefined){
      $('#jobmaster_ユーザ番号').val(kaisha[0]);
        $('#jobmaster_ユーザ名').val(kaisha[1]);
        $('#jobmaster_ユーザ番号').closest('.form-group').find('.span.help-block').text('');
        $('#jobmaster_ユーザ番号').closest('.form-group').removeClass('has-error');

        $('#bashomaster_会社コード').val(kaisha[0]);
        $('#bashomaster_会社コード').closest('.form-group').find('.span.help-block').text('');
        $('#bashomaster_会社コード').closest('.form-group').removeClass('has-error');
    }
    $('#kaisha-search-modal').modal('hide');
  });

});


$(function() {

    $('#destroy_kaishamaster').click(function(){
        var kaishamaster = oKaisha_modal.rows('tr.selected').data()
        var kaishaIds = new Array();
        if( kaishamaster == undefined)
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
                for (var i = 0; i < kaishamaster.length; i++) {
                  kaishaIds[i] = kaishamaster[i][0]
                }
                $.ajax({
                    url: '/kaishamasters/ajax',
                    data:{
                        focus_field: 'kaishamaster_削除する',
                        kaishas: kaishaIds
                    },

                    type: "POST",

                    success: function(data){
                        swal("削除されました!", "", "success");
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          var d = oKaisha_modal.row('tr.selected').data();
                          oKaisha_modal.rows('tr.selected').remove().draw();
                          if(d[0]==$('#jobmaster_ユーザ番号').val()){
                            $('#jobmaster_ユーザ番号').val('');
                            $('#jobmaster_ユーザ名').val('');
                          }
                          if(d[0]==$('#bashomaster_会社コード').val()){
                            $('#bashomaster_会社コード').val('');

                          }

                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("holiday_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_kaishamaster").addClass("disabled");
                $("#destroy_kaishamaster").addClass("disabled");
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    $("#edit_kaishamaster").attr("disabled", false)
                    $("#destroy_kaishamaster").attr("disabled", false)
                }
            });
        }
    });



    $('#new_kaishamaster').click(function(){
        $('#kaisha-new-modal').modal('show');

        $('#kaisha-new-modal #kaishamaster_会社コード').val('');
        $('#kaisha-new-modal #kaishamaster_会社名').val('');
        $('#kaisha-new-modal #kaishamaster_備考').val('');

        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_kaishamaster').click(function(){
        var kaishamaster = oKaisha_modal.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (kaishamaster == undefined)
          swal("行を選択してください。");
        else{

            $('#kaisha-edit-modal').modal('show');
            $('#kaisha-edit-modal #kaishamaster_会社コード').val(kaishamaster[0]);
            $('#kaisha-edit-modal #kaishamaster_会社名').val(kaishamaster[1]);
            $('#kaisha-edit-modal #kaishamaster_備考').val(kaishamaster[2]);
        }

    });




});
