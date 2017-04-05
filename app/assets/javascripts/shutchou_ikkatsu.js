/**
 * Created by cmc on 05/04/2017.
 */

//toggle_calendar
$(function () {
    if($('#event1_状態コード').val() == ''){
        $('#event1_start').prop('disabled',true);
        $('#event1_end').prop('disabled',true);
    }else{
        $('#event1_start').attr('disabled',false);
        $('#event1_end').attr('disabled',false);
    }

    if($('#event3_状態コード').val() == ''){
        $('#event3_start').prop('disabled',true);
        $('#event3_end').prop('disabled',true);
    }else{
        $('#event3_start').attr('disabled',false);
        $('#event3_end').attr('disabled',false);
    }
});
$(function () {

    $('#event_開始').click(function () {
        $('.event_開始 .datetime').data("DateTimePicker").toggle();
    });
    $('#event_終了').click(function () {
        $('.event_終了 .datetime').data("DateTimePicker").toggle();
    });

    $('#event1_start').click(function () {
        $('.event1_start .datetime').data("DateTimePicker").toggle();
    });
    $('#event1_end').click(function () {
        $('.event1_end .datetime').data("DateTimePicker").toggle();
    });

    $('#event3_start').click(function () {
        $('.event3_start .datetime').data("DateTimePicker").toggle();
    });
    $('#event3_end').click(function () {
        $('.event3_end .datetime').data("DateTimePicker").toggle();
    });

    $('#mybasho_destroy').click(function (){
        var mybasho_id = oMybashoTable.row('tr.selected').data();
        var shain = $('#event_社員番号').val();
        if( mybasho_id == undefined)
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
                    url: '/events/ajax',
                    data: {id: 'mybasho_削除する',mybasho_id: mybasho_id[1],shain: shain},
                    type: "POST",

                    success: function(data) {
                       if(data.destroy_success != null){
                            console.log("getAjax destroy_success:"+ data.destroy_success);
                            oMybashoTable.rows('tr.selected').remove().draw();
                        }
                        else{
                            console.log("getAjax destroy_success:"+ data.destroy_success);
                        }
                    },
                    failure: function() {
                        console.log("mybasho_削除する keydown Unsuccessful");
                    }
                });
                $("#mybasho_destroy").attr("disabled", true);
            }, function(dismiss) {
                if (dismiss === 'cancel') {
                    $("#myjob_destroy").attr("disabled", false);
                }
            });
        }

    });

    $('#myjob_destroy').click(function (){
        var myjob_id = oMyjobTable.row('tr.selected').data();
        var shain = $('#event_社員番号').val();

        if( myjob_id == undefined)
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
                    url: '/events/ajax',
                    data: {id: 'myjob_削除する',myjob_id: myjob_id[1],shain: shain},
                    type: "POST",

                    success: function(data) {
                       if(data.destroy_success != null){
                            console.log("getAjax destroy_success:"+ data.destroy_success);
                            oMyjobTable.rows('tr.selected').remove().draw();
                        }
                        else{

                            console.log("getAjax destroy_success:"+ data.destroy_success);
                        }
                    },
                    failure: function() {
                        console.log("myjob_削除する keydown Unsuccessful");
                    }
                });
                $("#myjob_destroy").attr("disabled", true);

            }, function(dismiss) {
                if (dismiss === 'cancel') {
                    $("#myjob_destroy").attr("disabled", false);
                }
            });
        }
    });


    $('#mybasho_sentaku_ok').click(function(){
        var d = oMybashoTable.row('tr.selected').data();
        if(d!= undefined){
            $('#event_場所コード').val(d[1]);
            $('.hint-basho-refer').text(d[2]);
            $('#event_場所コード').closest('.form-group').find('span.help-block').remove();
            $('#event_場所コード').closest('.form-group').removeClass('has-error');
        }
    });

    $('#myjob_sentaku_ok').click(function(){
        var d = oMyjobTable.row('tr.selected').data();
        if(d!= undefined){
            $('#event_JOB').val(d[1]);
            $('.hint-job-refer').text(d[2]);
            $('#event_JOB').closest('.form-group').find('span.help-block').remove();
            $('#event_JOB').closest('.form-group').removeClass('has-error');
        }
    });

    $('#clear_mybasho').click(function () {

        oMybashoTable.$('tr.selected').removeClass('selected');
        oMybashoTable.$('tr.success').removeClass('success');
        $("#mybasho_destroy").attr("disabled", true);

    } );



    $('#clear_myjob').click(function () {

        oMyjobTable.$('tr.selected').removeClass('selected');
        oMyjobTable.$('tr.success').removeClass('success');
        $("#myjob_destroy").attr("disabled", true);
    } );


});

//date field click handler
$(function () {

    $('.datetime').datetimepicker({
        format: 'YYYY/MM/DD HH:mm',
        showTodayButton: true,
        showClear: true,
        sideBySide: true,
        calendarWeeks: true,
        toolbarPlacement: 'top',
        keyBinds: false,
        focusOnShow: false
    });
});

// init search table
$(function(){
    oTable = $('#user_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        },
        columnDefs: [{
                targets: [0],
                orderData: [2, 3, 0]
            }
            ,{
                "targets": [2, 3],
                "visible": false,
                "searchable": false
            }
        ]
    });


    oMybashoTable = $('#mybasho_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });

    oMyjobTable = $('#myjob_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });



    //選択された行を判断
    $('#user_table tbody').on( 'click', 'tr', function () {

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



    $('#mybasho_table tbody').on( 'click', 'tr', function () {

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $("#mybasho_destroy").attr("disabled", true);
        }
        else {
            oMybashoTable.$('tr.selected').removeClass('selected');
            oMybashoTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $("#mybasho_destroy").attr("disabled", false);
        }
    } );


    $('#myjob_table tbody').on( 'click', 'tr', function () {

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $("#myjob_destroy").attr("disabled", true);
        }
        else {
            oMyjobTable.$('tr.selected').removeClass('selected');
            oMyjobTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $("#myjob_destroy").attr("disabled", false);
        }

    } );

    $('#user_refer_sentaku_ok').click(function(){
        var d = oTable.row('tr.selected').data();
        if(d!=undefined){
            $('#jobmaster_入力社員番号').val(d[0])
            $('.hint-shain-refer').text(d[1])
        }
    });

    // auto fill time start of event 2 when fill time end of event 1
    $(".event1_end .datetime").on("dp.change", function (e) {
        var event1_end = $("#event1_end").val();
        if(event1_end != ''){
            $("#event_開始").val(event1_end);
        }
    });
    //auto fill time start of event 3 when fill time end of event 2
    $(".event_終了 .datetime").on("dp.change", function (e) {
        var event_end = $("#event_終了").val();
        if(event_end != ''){
            $("#event3_状態コード").val(13);
            $("#event3_start").val(event_end);
            $('#event3_start').attr('disabled',false);
            $('#event3_end').attr('disabled',false);
        }
    });
    //when change value of joutai1
    $("#event1_状態コード").on("change", function (e) {
        var event1_joutai = $("#event1_状態コード").val();
        if(event1_joutai != ''){
            $('#event1_start').attr('disabled',false);
            $('#event1_end').attr('disabled',false);
        }else{
            $('#event1_start').attr('disabled',true);
            $('#event1_end').attr('disabled',true);
            $('#event1_start').val('');
            $('#event1_end').val('');
        }
    });
    //when change value of joutai3
    $("#event3_状態コード").on("change", function (e) {
        var event3_joutai = $("#event3_状態コード").val();
        if(event3_joutai != ''){
            $('#event3_start').attr('disabled',false);
            $('#event3_end').attr('disabled',false);
        }else{
            $('#event3_start').attr('disabled',true);
            $('#event3_end').attr('disabled',true);
            $('#event3_start').val('');
            $('#event3_end').val('');
        }
    });
    //when click create
    $('#update_shutchou').click(function(e){
        $('.form-group.has-error').each(function(){
          $('.help-block', $(this)).html('');
          $(this).removeClass('has-error');
        });
        var event_start = $('#event_開始').val();
        var event_end = $('#event_終了').val();

        var event1_start = $('#event1_start').val();
        var event1_end = $('#event1_end').val();

        var event3_start = $('#event3_start').val();
        var event3_end = $('#event3_end').val();

        var event1_joutai = $("#event1_状態コード").val();
        var event3_joutai = $("#event3_状態コード").val()
        if(event_start == ''){
            $input = $('#event_開始');
            $input.closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
            e.preventDefault();
        }
        if(event_end == ''){
            $input = $('#event_終了');
            $input.closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
            e.preventDefault();
        }
        if(event_start!= '' && event_end != ''){
            var diff = moment(event_end,'YYYY/MM/DD HH:mm').diff(moment(event_start,'YYYY/MM/DD HH:mm'),'hours', true);
            if(diff < 0){
                $('#event_終了').closest('.form-group').addClass('has-error').find('.help-block').text("は開始日以上の値にしてください。");
                e.preventDefault();
            }
        }
        if(event1_joutai == '' && event3_joutai == ''){
            $("#event1_状態コード").closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
            $("#event3_状態コード").closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
            e.preventDefault();
        }
        if(event1_joutai != ''){
            if(event1_start == ''){
                $('#event1_start').closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
                e.preventDefault();
            }
            if(event1_end == ''){
                $('#event1_end').closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
                e.preventDefault();
            }
            if(event1_start!= '' && event1_end != ''){
                var diff = moment(event1_end,'YYYY/MM/DD HH:mm').diff(moment(event1_start,'YYYY/MM/DD HH:mm'),'hours', true);
                if(diff < 0){
                    $('#event1_end').closest('.form-group').addClass('has-error').find('.help-block').text("は開始日以上の値にしてください。");
                    e.preventDefault();
                }
            }
        }
        if(event3_joutai != ''){
            if(event3_start == ''){
                $('#event3_start').closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
                e.preventDefault();
            }
            if(event3_end == ''){
                $('#event3_end').closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");
                e.preventDefault();
            }
            if(event3_start!= '' && event3_end != ''){
                var diff = moment(event3_end,'YYYY/MM/DD HH:mm').diff(moment(event3_start,'YYYY/MM/DD HH:mm'),'hours', true);
                if(diff < 0){
                    $('#event3_end').closest('.form-group').addClass('has-error').find('.help-block').text("は開始日以上の値にしてください。");
                    e.preventDefault();
                }
            }
        }
    })

});


// keydown trigger
$(function(){
    $('#event_状態コード').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var event_joutai = $("#event_状態コード").val();
            if (!event_joutai) return
            jQuery.ajax({
                url: '/events/ajax',
                data: {id: 'event_状態コード',event_joutai_code: event_joutai},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    //$('#job_name').text(data.job_name);
                    if (data.joutai_name != null){
                      $('.hint-joutai-refer').text(data.joutai_name);
                      console.log("getAjax joutai_name:"+ data.joutai_name);
                    }
                    else{
                      $('.hint-joutai-refer').text('');
                      console.log("getAjax joutai_name:"+ data.joutai_name);
                    }
                },
                failure: function() {
                    console.log("event_状態コード keydown Unsuccessful");
                }
            });

        }
    });

    $('#event_場所コード').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var event_basho = $('#event_場所コード').val();
            if (!event_basho) return
            jQuery.ajax({
                url: '/events/ajax',
                data: {id: 'event_場所コード',event_basho_code: event_basho},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    if (data.basho_name != null){
                    //$('#basho_name').text(data.basho_name);
                        $('.hint-basho-refer').text(data.basho_name);
                        console.log("getAjax basho_name:"+ data.basho_name);
                    }
                    else{
                      $('.hint-basho-refer').text('');
                      console.log("getAjax basho_name:"+ data.basho_name);
                    }
                },
                failure: function() {
                    console.log("event_場所コード keydown Unsuccessful");
                }
            });
        }
    });

    $('#event_工程コード').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var event_koutei_code = $('#event_工程コード').val();
            jQuery.ajax({
                url: '/events/ajax',
                data: {id: 'event_工程コード',event_koutei_code: event_koutei_code},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    //$('#koutei_name').text(data.koutei_name);
                    if(data.koutei_name != null){
                        $('.hint-koutei-refer').text(data.koutei_name);
                        console.log("getAjax koutei_name:"+ data.koutei_name);
                    }
                    else{
                      $('.hint-koutei-refer').text('');
                      console.log("getAjax koutei_name:"+ data.koutei_name);
                    }
                },
                failure: function() {
                    console.log("event_工程コード keydown Unsuccessful");
                }
            });
        }
    });


    $('#event_JOB').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var event_job_code = $('#event_JOB').val();
            if (!event_job_code) return

            jQuery.ajax({
                url: '/events/ajax',
                data: {id: 'event_job',event_job_code: event_job_code},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    if(data.job_name != null){
                    //$('#job_name').text(data.job_name);
                        $('.hint-job-refer').text(data.job_name);
                        console.log("getAjax job_name:"+ data.job_name);
                    }
                    else{
                      $('.hint-job-refer').text('');
                      console.log("getAjax job_name:"+ data.job_name);
                    }
                },
                failure: function() {
                    console.log("event_job番号 keydown Unsuccessful");
                }
            });
        }
    });

});
