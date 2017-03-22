$(document).ready(function(){
    $("#edit_jobmaster").attr("disabled", true);
    $("#destroy_jobmaster").attr("disabled", true);
    oJobTable = $('#job_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });
    oJob_Table = $('#job_table_in_job').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });
    $(document).bind('ajaxError', 'form#new_jobmaster', function(event, jqxhr, settings, exception){
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
  $('.date').datetimepicker({
        format: 'YYYY/MM/DD',
        widgetPositioning: {
            horizontal: 'left'
        },
        showTodayButton: true,
        keyBinds: false,
        focusOnShow: false

    });
  $('#job-new-modal #jobmaster_開始日').click( function(){
    $('#job-new-modal .jobmaster_開始日 .date').data("DateTimePicker").toggle();
  });

  $('#job-new-modal #jobmaster_終了日').click( function(){
    $('#job-new-modal .jobmaster_終了日 .date').data("DateTimePicker").toggle();
  })

  $('#job-edit-modal #jobmaster_開始日').click( function(){
    $('#job-edit-modal .jobmaster_開始日 .date').data("DateTimePicker").toggle();
  });

  $('#job-edit-modal #jobmaster_終了日').click( function(){
    $('#job-edit-modal .jobmaster_終了日 .date').data("DateTimePicker").toggle();
  })

  $('.search-field').click( function(){
    var element1 = $('.search-group').find('#jobmaster_ユーザ番号')
    var element2 = $('.search-group').find('#jobmaster_入力社員番号')
    var element3 = $('.search-group').find('#jobmaster_関連Job番号')

    if( $(this).prev().is(element1))
      $('#kaisha-search-modal').modal('show')

    if( $(this).prev().is(element2))
      $('#select_user_modal').modal('show')

    if( $(this).prev().is(element3))
      $('#job_search_in_job_modal').modal('show')
  })
  //JOB選択された行を判断
  $('#job_table tbody').on( 'click', 'tr', function () {
    var d = oJobTable.row(this).data();
    $('#event_JOB').val(d[0]);
    $('.hint-job-refer').text(d[1])

    if ( $(this).hasClass('selected') ) {
        $(this).removeClass('selected');
        $(this).removeClass('success');
        $("#edit_jobmaster").attr("disabled", true);
        $("#destroy_jobmaster").attr("disabled", true);
    }
    else {
        oJobTable.$('tr.selected').removeClass('selected');
        oJobTable.$('tr.success').removeClass('success');
        $(this).addClass('selected');
        $(this).addClass('success');
        $("#edit_jobmaster").attr("disabled", false);
        $("#destroy_jobmaster").attr("disabled", false);
    }

  });

  $('#job_table_in_job tbody').on( 'click', 'tr', function () {

        var d = oJob_Table.row(this).data();

        $('#jobmaster_関連Job番号').val(d[0])
        $('.hint-job-refer').text(d[1])

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
        }
        else {
            oJob_Table.$('tr.selected').removeClass('selected');
            oJob_Table.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );
   $('#clear_job').click(function () {
        $('#event_JOB').val('');
        $('.hint-job-refer').text('')
        $('#event_JOB').closest('.form-group').find('span.help-block').remove();
        $('#event_JOB').closest('.form-group').removeClass('has-error');
        oJobTable.$('tr.selected').removeClass('selected');
        oJobTable.$('tr.success').removeClass('success');
    } );
  $('#job_sentaku_ok').click(function(){

        var myjob_id = oJobTable.row('tr.selected').data();
        var shain = $('#event_社員番号').val();
        $.ajax({
            url: '/events/ajax',
            data: {id: 'job_selected',myjob_id: myjob_id[0],shain: shain},
            type: "POST",

            success: function(data) {
               if(data.myjob_id != null){
                    console.log("getAjax myjob_id:"+ data.myjob_id);

                }
                else{

                    console.log("getAjax myjob_id:"+ data.myjob_id);
                }
            },
            failure: function() {
                console.log("job_selected keydown Unsuccessful");
            }
        });
    });

});


$(function() {

    $('#destroy_jobmaster').click(function(){
        var jobmaster = oJobTable.rows('tr.selected').data()
        var jobIds = new Array();
        if( jobmaster == undefined)
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
                for (var i = 0; i < jobmaster.length; i++) {
                  jobIds[i] = jobmaster[i][0]
                }

                $.ajax({
                    url: '/jobmasters/ajax',
                    data:{
                        focus_field: 'jobmaster_削除する',
                        jobs: jobIds
                    },

                    type: "POST",

                    success: function(data){
                        swal("削除されました!", "", "success");
                        if (data.destroy_success != null){
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                          oJobTable.rows('tr.selected').remove().draw();
                          $('#event_JOB').val('');
                          $('.hint-job-refer').text('')
                        }else
                          console.log("getAjax destroy_success:"+ data.destroy_success);
                     },
                     failure: function(){
                        console.log("holiday_削除する keydown Unsuccessful");
                     }


                });
                $("#edit_jobmaster").attr("disabled", true);
                $("#destroy_jobmaster").attr("disabled", true);
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    $("#edit_jobmaster").attr("disabled", false)
                    $("#destroy_jobmaster").attr("disabled", false)
                }
            });
        }
    });



    $('#new_jobmaster').click(function(){
        $('#job-new-modal').modal('show');

        $('#job-new-modal #jobmaster_job番号').val('');
        $('#job-new-modal #jobmaster_job名').val('');
        $('#job-new-modal #jobmaster_開始日').val('');
        $('#job-new-modal #jobmaster_終了日').val('');
        $('#job-new-modal #jobmaster_ユーザ番号').val('');
        $('#job-new-modal #jobmaster_ユーザ名').val('');
        $('#job-new-modal #jobmaster_入力社員番号').val('');
        $('#job-new-modal .hint-shain-refer').text('');

        $('#job-new-modal #jobmaster_分類コード').val('');
        $('#job-new-modal #jobmaster_関連Job番号').val('');
        $('#job-new-modal .hint-job-refer').text('');
        $('#job-new-modal #jobmaster_備考').val('');
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

    });


    $('#edit_jobmaster').click(function(){
        var jobmaster = oJobTable.row('tr.selected').data();
        $('.form-group.has-error').each( function(){
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });

        if (jobmaster == undefined)
          swal("行を選択してください。");
        else{
            jQuery.ajax({
                url: '/events/ajax',
                data: {id: 'get_job_selected',job_id: jobmaster[0]},
                type: "POST",
                success: function(data) {
                  $('#job-edit-modal').modal('show');
                  $('#job-edit-modal #jobmaster_job番号').val(data.job.job番号);
                  $('#job-edit-modal #jobmaster_job名').val(data.job.job名);
                  $('#job-edit-modal #jobmaster_開始日').val(data.job.開始日);
                  $('#job-edit-modal #jobmaster_終了日').val(data.job.終了日);
                  $('#job-edit-modal #jobmaster_ユーザ番号').val(data.job.ユーザ番号);
                  $('#job-edit-modal #jobmaster_ユーザ名').val(data.job.ユーザ名);
                  $('#job-edit-modal #jobmaster_入力社員番号').val(data.job.入力社員番号);
                  $('#job-edit-modal .hint-shain-refer').text('');

                  $('#job-edit-modal #jobmaster_分類コード').val(data.job.分類コード);
                  $('#job-edit-modal #jobmaster_関連Job番号').val(data.job.関連Job番号);
                  $('#job-edit-modal .hint-job-refer').text('');
                  $('#job-edit-modal #jobmaster_備考').val(data.job.備考);
                },
                failure: function() {
                    console.log("event_状態コード keydown Unsuccessful");
                }
            });

        }

    });



});
