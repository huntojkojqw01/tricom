/**
 * Created by cmc on 18/03/2015.
 */

//calendar init
var calendar;
$(function(){
    //var firstHour = new Date().getUTCHours();
    var scroll = -1,
        viewNames = ['agendaWeek', 'agendaDay', 'timelineDay'];

    $('body').on('click', 'button.fc-prev-button', function() {
        var text = $('.fc-left').text();
    });

    $.getJSON('/events', function(data) {
        var myEventSourses = '';
        if(data.setting.select_holiday_vn == "1")
            myEventSourses = [
                    {
                        googleCalendarId: 'en.japanese#holiday@group.v.calendar.google.com',
                        color: 'green'
                    }
                    ,{
                        googleCalendarId: 'en.vietnamese#holiday@group.v.calendar.google.com',
                        color: 'blue'
                    }
                ];
        else
            myEventSourses = [
                    {
                        googleCalendarId: 'en.japanese#holiday@group.v.calendar.google.com',
                        color: 'green'
                    }
                ];
        calendar = $('#calendar-month-view').fullCalendar(
            {
                schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
                //height: 1287,
                //height: 1500,
                //firstHour: '09:00',
                //businessHours:{
                //    start: '09:00:00', // a start time (09am in this example)
                //    end: '18:00:00', // an end time (6pm in this example)
                //
                //    dow: [1, 2, 3, 4, 5]
                //    // days of week. an array of zero-based day of week integers (0=Sunday)
                //    // (Monday-Freeday in this example)
                //},
                firstDay: 1,
                timeFormat: 'H:mm',
                //editable: true,
                //aspectRatio: 1.5,/
                //resourceAreaWidth: '30%',
                slotLabelFormat: ['HH : mm'],
                //scrollTime: '06:00:00',
                //slotDuration: moment.duration(0.5, 'hours'),
                //minTime: '00:00:00',
                //maxTime: '24:00:00',
                //eventOverlap: false,
                nowIndicator: true,
                googleCalendarApiKey: 'AIzaSyDOeA5aJ29drd5dSAqv1TW8Dvy2zkYdsdk',
                eventSources: myEventSourses,
                schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
                //defaultView: 'timelineDay',
                events: data.my_events,
                //events: '/events.json',
                header: {
                    left:   'title',
                    // center: 'month,agendaWeek,agendaDay prevYear,nextYear',
                    center: 'month,agendaWeek,agendaDay today prev,next',
                    right:  ''
                },
                dragOpacity: "0.5",
                editable: true,
                dayClick: function(date, jsEvent, view) {
                   //window.open('http://misuzu.herokuapp.com/events/new?start_at='+date.format());
                   var calendar = document.getElementById('calendar-month-view');

                    calendar.ondblclick = function() {
                       location.href='/events/new?start_at='+date.format();

                    }
                    //alert(data.sUrl);
                },
                dayRender: function(date, element, view){
                        jQuery.ajax({
                        url: '/events/ajax',
                        data: {id: 'kintai_getData', date_kintai: date.format()},
                        type: "POST",
                        // processData: false,
                        // contentType: 'application/json',

                        success: function(data) {
                            var color = element.css("background-color");
                            element.append("<button id='bt-hoshu-1"+date.format()+"' onclick='showModal(\""+date.format()+"\",\"0\"); return false;' "+
                                    "value=1 class='btn btn-hoshu' type='button'>携帯</button>"+
                                    "<button id='bt-hoshu-0"+date.format()+"' onclick='showModal(\""+date.format()+"\",\"1\"); return false;' "+
                                    "value=0 class='btn btn-text' style='background-color:"+color+"' type='button'>携帯</button>");
                            if(data.kintai_hoshukeitai == 1){
                                $('#bt-hoshu-1'+date.format()).show();
                                $('#bt-hoshu-0'+date.format()).hide();
                                // element.append("<a id='abc' value=100 onclick='showModal(\""+date.format()+"\"); return false;' style='cursor: pointer;'><i class='fa fa-pencil'>"+data.kintai_hoshukeitai+"</i></a>");
                                console.log("getAjax kintai_id:"+ data.kintai_hoshukeitai);
                            }
                            else{
                                $('#bt-hoshu-1'+date.format()).hide();
                                $('#bt-hoshu-0'+date.format()).show();
                                console.log("getAjax kintai_id:"+ data.kintai_hoshukeitai);
                            }
                        },
                        failure: function() {
                            console.log("kintai_保守携帯回数 keydown Unsuccessful");
                        }
                    });


                    // var date_convert = new Date(date.format());
                    // if(date_convert.getDay()!==6 && date_convert.getDay()!==0&&hoshukeitai!=null)
                    //     element.append("<a id='abc' value=100 onclick='showModal(\""+date.format()+"\"); return false;' style='cursor: pointer;'><i class='fa fa-pencil'>"+hoshukeitai+"</i></a>");
                    // var date_convert = new Date(date.format());
                    // if(date_convert.getDay()!==6 && date_convert.getDay()!==0)
                    //     element.append("<a id='abc' onclick='showModal(\""+date.format()+"\"); return false;' style='cursor: pointer;'><i class='fa fa-pencil'>保守携帯</i></a>");
                },
                //eventRender: function(event, element, view) {
                //    element.qtip({
                //        content: event.description
                //    });
                //},
                eventRender: function(event, element, view) {
                    if (view.name === "agendaDay" || view.name === "agendaWeek") {
                        if(event.job != undefined || event.comment != undefined){
                            element.find(".fc-title")
                            .replaceWith('<div>'+event.job+'</div>'+'<div>'+event.comment+'</div>');
                        }
                    }
                },
                eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
                   // alert(event.title + " was dropped on " + event.start.format());
                    updateEvent(event);
                },


                eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
                    updateEvent(event);
                }
                ,eventMouseover: function(event, jsEvent, view) {
                    var tooltip = '<div class="tooltipevent hover-end">' +'<div>'+ event.start.format("YYYY/MM/DD HH:mm") +'</div>' +'<div>'+ event.end.format("YYYY/MM/DD HH:mm")+'</div>' +'<div>'+ event.title +'</div>' ;
                    if(event.job != undefined){
                        tooltip = tooltip + '<div>'+event.job+'</div>'
                    }
                    if(event.comment != undefined){
                        tooltip = tooltip + '<div>'+event.comment+'</div>'
                    }
                    tooltip = tooltip +'</div>'
                    $("body").append(tooltip);
                    $(this).mouseover(function(e) {
                        $(this).css('z-index', 10000);
                        $('.tooltipevent').fadeIn('500');
                        $('.tooltipevent').fadeTo('10', 1.9);
                    }).mousemove(function(e) {
                        $('.tooltipevent').css('top', e.pageY + 10);
                        $('.tooltipevent').css('left', e.pageX + 20);
                    });
                },

                eventMouseout: function(event, jsEvent, view) {
                    $(this).css('z-index', 8);
                    $('.tooltipevent').remove();
                }
            }
            );
        //scroll calendar to date
        calendar.fullCalendar('gotoDate', moment($('#goto_date').val()));
        oTable = $('#event_table').DataTable();
        oTable.draw();
        //Hander calendar header button click
        $('#month-view').find('#goto-date-button, .fc-today-button,.fc-prev-button,.fc-next-button').click(function(){
            //redraw dataTable after filter
            oTable = $('#event_table').DataTable();
            oTable.draw();
            //set current date to hidden field to goback, post it to session
            $.post(
                "/settings/ajax",
                {
                    setting: "setting_date",
                    selected_date: $('#calendar-month-view').fullCalendar('getDate').format()
                }
            );
        });

        //add jpt holiday
        $('#calendar-month-view').fullCalendar('addEventSource',data.holidays);

    });

});

$(document).ready(function(){
    $('#after_div').hide();
    $('#hide_event_button').hide();

    // $('#month-view').show('fast',function(){
    //     $('#after_div').show();
    // });
    // $('#after_div').modal('hide');
    $(document).bind('ajaxError', 'form#new_mybashomaster', function(event, jqxhr, settings, exception){

        // note: jqxhr.responseJSON undefined, parsing responseText instead
        $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

    });

    $(document).bind('ajaxError', 'form#new_kaishamaster', function(event, jqxhr, settings, exception){

        // note: jqxhr.responseJSON undefined, parsing responseText instead
        $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

    });
});

//Add filter for datatable
$(function () {
    $.fn.dataTableExt.afnFiltering.push(
        function(oSettings, aData, iDataIndex){
            var dateStart = getStartCalendarMonthbegin( $('.fc-left').text());
            // var dateStart = parseDateValue($("#dateStart").val());
            // var dateEnd = parseDateValue($("#dateEnd").val());
            // aData represents the table structure as an array of columns, so the script access the date value
            // in the first column of the table via aData[0]
            var evalDate = parseDateValue(aData[1]);
            console.log("ngay: " + dateStart);
            console.log("ngay-: " + evalDate);
            if (evalDate >= dateStart) {
                return true;
            }
            else {
                return false;
            }
        });
});

function getStartCalendarMonthbegin(dateString){
    console.log(dateString.length);
    var res = dateString.substring(0, 4);

    if ( dateString.charAt(5) == " " ) {
        if (isNum(dateString.charAt(6)) && isNum(dateString.charAt(7)))
            res +=dateString.substring(6,8);
        else res += "0" + dateString.substring(6,7);
        res += "01";
    }
    else{
        if ( isNum(dateString.charAt(5)) && isNum(dateString.charAt(6))){
            res+=dateString.substring(5,7);
            if ( isNum(dateString.charAt(8)) && isNum(dateString.charAt(9)))
                res+=dateString.substring(8,10);
            else res+= "0"+dateString.substring(8,9);
        }
        else {
            res+= "0"+dateString.substring(5,6);
            if ( isNum(dateString.charAt(7)) && isNum(dateString.charAt(8)))
                res+=dateString.substring(7,9);
            else res+= "0"+dateString.substring(7,8);

        }
    }
    return res ;
}

function parseDateValue(rawDate) {
    var dateArray= rawDate.substring(0,10).split("/");
    var parsedDate= dateArray[0] + dateArray[1] + dateArray[2];
    return parsedDate;
}

function isNum(c){
    return (c >= '0' && c <= '9' )
}

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

// readjust sizing after font load
$(window).on('load', function() {
    $('#calendar-timeline').fullCalendar('render');
    $('#goto-date-input').val(moment().format('YYYY/MM/DD'));
    var strtime = new Date($("#event_開始").val());

    var joutai = $('#event_状態コード').val()
    var joutai_kubun = ''
    oJoutaiTable.rows().every( function( rowIdx, tableLoop, rowLoop ){
        var data = this.data();
        if( data[0] == joutai){
            joutai_kubun = data[3]
        }
    });
    if (joutai_kubun == '1' || joutai_kubun == '5') {
        $('#event_場所コード').prop( "disabled", false );
        $('#event_JOB').prop( "disabled", false );
        $('#event_工程コード').prop( "disabled", false );
        $('#basho_search').prop( "disabled", false );
        $('#koutei_search').prop( "disabled", false )
    }else {
        $('#event_場所コード').prop( "disabled", true );
        $('#event_JOB').prop( "disabled", true );
        $('#event_工程コード').prop( "disabled", true );
        $('#basho_search').prop( "disabled", true );
        $('#koutei_search').prop( "disabled", true );
    }

});

//toggle_calendar
$(function () {
    $('#goto-date-input').click(function () {
        $('.datetime_search').data("DateTimePicker").toggle();
    });
    $('#event_開始').click(function () {
        $('.event_開始 .datetime').data("DateTimePicker").toggle();
    });
    $('#event_終了').click(function () {
        $('.event_終了 .datetime').data("DateTimePicker").toggle();
    });
    $('#save').click(function () {
        var hoshukeitai = $("#kintai_保守携帯回数").val();
        var date_kintai = $("#kintai_日付").val();
        if (!date_kintai || !hoshukeitai) return
        jQuery.ajax({
            url: '/events/ajax',
            data: {id: 'kintai_保守携帯回数',hoshukeitai: hoshukeitai, date_kintai: date_kintai},
            type: "POST",
            // processData: false,
            // contentType: 'application/json',

            success: function(data) {
               if(data.kintai_id != null){
                    console.log("getAjax kintai_id:"+ data.kintai_id);
                }
                else{

                    console.log("getAjax kintai_id:"+ data.kintai_id);
                }
            },
            failure: function() {
                console.log("kintai_保守携帯回数 keydown Unsuccessful");
            }
        });
        $('#kintai-new-modal').modal('hide');
    });
    $('#hide_event_button').click(function () {
        $('#hide_event_button').hide();
        $('#show_event_button').show()
        $('#after_div').hide();
    });
    $('#show_event_button').click(function () {
        $('#hide_event_button').show();
        $('#show_event_button').hide()
        $('#after_div').show();
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
                $("#mybasho_destroy").addClass("disabled");
            }, function(dismiss) {
                if (dismiss === 'cancel') {
                    $("#myjob_destroy").removeClass("disabled");
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
                $("#myjob_destroy").addClass("disabled");

            }, function(dismiss) {
                if (dismiss === 'cancel') {
                    $("#myjob_destroy").removeClass("disabled");
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

    $('#mybasho_table tbody').on( 'dblclick', 'tr', function () {
        $(this).addClass('selected');
        $(this).addClass('success');
        var d = oMybashoTable.row('tr.selected').data();
        if(d!= undefined){
            $('#event_場所コード').val(d[1]);
            $('.hint-basho-refer').text(d[2]);
            $('#event_場所コード').closest('.form-group').find('span.help-block').remove();
            $('#event_場所コード').closest('.form-group').removeClass('has-error');
        }
        $('#mybasho_search_modal').modal('hide')
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

    $('#myjob_table tbody').on( 'dblclick', 'tr', function () {
        $(this).addClass('selected');
        $(this).addClass('success');
        var d = oMyjobTable.row('tr.selected').data();
        if(d!= undefined){
            $('#event_JOB').val(d[1]);
            $('.hint-job-refer').text(d[2]);
            $('#event_JOB').closest('.form-group').find('span.help-block').remove();
            $('#event_JOB').closest('.form-group').removeClass('has-error');
        }
        $('#myjob_search_modal').modal('hide')
    });

    $('#clear_mybasho').click(function () {

        oMybashoTable.$('tr.selected').removeClass('selected');
        oMybashoTable.$('tr.success').removeClass('success');
        $("#mybasho_destroy").addClass("disabled");

    } );



    $('#clear_myjob').click(function () {

        oMyjobTable.$('tr.selected').removeClass('selected');
        oMyjobTable.$('tr.success').removeClass('success');
        $("#myjob_destroy").addClass("disabled");
    } );

    $('#destroy_event').click(function(){
        var events = oEventTable.rows('tr.selected').data();
        var eventIds = new Array();
        if( events.length == 0)
          swal($('#message_confirm_select').text());
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
                var len = events.length;

                var i=0;
                for(i=0;i<len;i++)
                  eventIds[i] = events[i][0];

                $.ajax({
                  url: '/events/ajax',
                  data:{
                    id: 'event_destroy',
                    events: eventIds
                  },

                  type: "POST",

                  success: function(data){
                    swal("削除されました!", "", "success");
                    if (data.destroy_success != null){
                        console.log("getAjax destroy_success:"+ data.destroy_success);
                        oEventTable.rows('tr.selected').remove().draw();
                        // $("#event_table").dataTable().fnDeleteRow($('#event_table').find('tr.selected').remove());
                        // $("#event_table").dataTable().fnDraw();
                        for(i=0;i<len;i++)
                            $('#calendar-month-view').fullCalendar('removeEvents',eventIds[i]);

                    }else
                        console.log("getAjax destroy_success:"+ data.destroy_success);
                    },
                  failure: function(){
                    console.log("event_destroy keydown Unsuccessful");
                  }

                });

                $("#destroy_event").addClass("disabled");
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    var selects = oEventTable.rows('tr.selected').data();
                    if( selects.length == 0)
                      $("#destroy_event").addClass("disabled", true);
                    else
                      $("#destroy_event").removeClass("disabled");
                }
            });

        }
    });

     $('#export_event').click(function(){
        location.href='/events/export_csv.csv?locale=ja';
     });

    $('#print_event').click(function(){
        if( $("#selectDay").css('display') === 'none'){
            $("#selectDay").css('display', '');
            $("#print_event_job").addClass("disabled");
            $("#print_event_koutei").addClass("disabled");
            $("#print_pdf_event").css('display', '');
            $("#print_pdf_job").css('display', 'none');
            $("#print_pdf_koutei").css('display', 'none');
            var currentDate = new Date();
            var startOfWeek = moment().startOf('isoweek').format('YYYY/MM/DD');
            var endOfWeek   = moment().endOf('isoweek').format('YYYY/MM/DD');
            $("#date_start_input").val(startOfWeek);
            $("#date_end_input").val(endOfWeek);

        }
        else{
            $("#selectDay").css('display', 'none');
            $("#print_event_job").removeClass("disabled");
            $("#print_event_koutei").removeClass("disabled");
        }
    });
    $('#print_event_job').click(function(){
        if( $("#selectDay").css('display') === 'none'){
            $("#selectDay").css('display', '');
            $("#print_event").addClass("disabled");
            $("#print_event_koutei").addClass("disabled");
            $("#print_pdf_event").css('display', 'none');
            $("#print_pdf_job").css('display', '');
            $("#print_pdf_koutei").css('display', 'none');
            var currentDate = new Date();
            var startOfWeek = moment().startOf('isoweek').format('YYYY/MM/DD');
            var endOfWeek   = moment().endOf('isoweek').format('YYYY/MM/DD');
            $("#date_start_input").val(startOfWeek);
            $("#date_end_input").val(endOfWeek);
        }
        else{
            $("#selectDay").css('display', 'none');
            $("#print_event").removeClass("disabled");
            $("#print_event_koutei").removeClass("disabled");
        }
    });
    $('#print_event_koutei').click(function(){
        if( $("#selectDay").css('display') === 'none'){
            $("#selectDay").css('display', '');
            $("#print_event").addClass("disabled");
            $("#print_event_job").addClass("disabled");
            $("#print_pdf_event").css('display', 'none');
            $("#print_pdf_job").css('display', 'none');
            $("#print_pdf_koutei").css('display', '');
            var currentDate = new Date();
            var startOfWeek = moment().startOf('isoweek').format('YYYY/MM/DD');
            var endOfWeek   = moment().endOf('isoweek').format('YYYY/MM/DD');
            $("#date_start_input").val(startOfWeek);
            $("#date_end_input").val(endOfWeek);
        }
        else{
            $("#selectDay").css('display', 'none');
            $("#print_event").removeClass("disabled");
            $("#print_event_job").removeClass("disabled");
        }
    });
    $('#print_pdf_event').click(function(){
        window.open('/events/pdf_event_show.pdf?locale=ja&date_start='+$("#date_start_input").val()+'&date_end='+$("#date_end_input").val());
    });
    $('#print_pdf_job').click(function(){
        window.open('/events/pdf_job_show.pdf?locale=ja&date_start='+$("#date_start_input").val()+'&date_end='+$("#date_end_input").val());
    });
    $('#print_pdf_koutei').click(function(){
        window.open('/events/pdf_koutei_show.pdf?locale=ja&date_start='+$("#date_start_input").val()+'&date_end='+$("#date_end_input").val());
    });
    $('#date_start_input').click(function(){
        $('.date_start_select').data("DateTimePicker").toggle();
    });
    $('#date_end_input').click(function(){
        $('.date_end_select').data("DateTimePicker").toggle();
    });


});

//date field click handler
$(function () {

    $('#goto-date-input').datetimepicker({
        format: 'YYYY/MM/DD',
        widgetPositioning: {
            horizontal: 'left'
        },
        showTodayButton: true,
        showClear: true,
        //,daysOfWeekDisabled:[0,6]
        // ,calendarWeeks: true,
        keyBinds: false,
        focusOnShow: false

    });
    $('.datetime_search').datetimepicker({
        format: 'YYYY/MM/DD',
        widgetPositioning: {
                horizontal: 'left'
            },
        showTodayButton: true,
        showClear: true,
        sideBySide: true,
        //toolbarPlacement: 'top',
        keyBinds: false,
        focusOnShow: false
    });

    $('.date_start_select').datetimepicker({
        // minDate: "2017/02/01",
        // maxDate: "2017/02/28",
        format: 'YYYY/MM/DD'
    });
    $('.date_end_select').datetimepicker({
        format: 'YYYY/MM/DD'
    });

    $('.date_start_select_footer').datetimepicker({
        // minDate: "2017/02/01",
        // maxDate: "2017/02/28",
        format: 'YYYY/MM/DD'
    });
    $('.date_end_select_footer').datetimepicker({
        format: 'YYYY/MM/DD'
    });

    $(".event_開始 .datetime").on("dp.change", function (e) {

        var q = new Date();
        var m = q.getMonth();
        var d = q.getDate();
        var y = q.getFullYear();

        var date = new Date(y,m,d);

        var mydate = new Date($("#event_開始").val().substring(0,10));
        var strtime = new Date($("#event_開始").val());

        date = date.toString();
        mydate = mydate.toString();
        if(date === mydate)
        {
            $("#selectShozai").css('display', '');
        }
        else
        {
            $("#selectShozai").css('display', 'none');
        }
    });

    //$("#event_終了").on("dp.change", function (e) {
    //    $('#event_開始').data("DateTimePicker").maxDate(e.date);
    //});
});

//button handle
$(function(){

    $('#goto-date-button').click(function() {
        //$('#calendar').fullCalendar('next');
        date_input = $('#goto-date-input').val();
        date = moment(date_input);
        $('#calendar-month-view').fullCalendar('gotoDate',date);
        $('#calendar-timeline').fullCalendar('gotoDate',date);
    });

    $('#search_user').click(function(){
        $('#select_user_modal').modal('show');
    });

});

// init search table
$.fn.dataTable.ext.buttons.import = {
    className: 'buttons-import',
    action: function ( e, dt, node, config ) {
        $('#import-csv-modal').modal('show');
    }
};
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
        ,"order": [[0, "asc"], [1, "asc"]]
    });


    oKouteiTable = $('#koutei_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });

    oShozaiTable = $('#shozai_table').DataTable({
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
        ,"order": [[0, "asc"], [1, "asc"]]
    });
    // Event table in shousai modal
    oEventTable = $('#event_table').DataTable({
        //"scrollX": true,
        "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
        "pagingType": "full_numbers",
        "fnDrawCallback": function( oSettings ) {
            $('.new-btn').appendTo($('.dt-buttons'));
            $('.edit-btn').appendTo($('.dt-buttons'));
            $('.delete-btn').appendTo($('.dt-buttons'));
        },
        "pageLength" : 50,
        "oLanguage":{"sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"},
        "aoColumnDefs": [
            // {"aTargets": [1], "mRender": function (data, type, full) {
            //     return '<a href="/events/' + data + '/edit">詳細</a>';
            //     }
            // },
            {"aTargets": [1,2], "mRender": function (data, type, full) {
                var time_format = moment(data, 'YYYY/MM/DD HH:mm').format('YYYY/MM/DD HH:mm');
                if (time_format !== 'Invalid date'){
                    return time_format;
                    }else return '';
                }
            },
            { "bSortable": false, "aTargets": [ 0,9 ]},
            {"targets": [ 0,9 ],"searchable": false},
            {"targets": [ 0 ],"visible": false }
            //{"targets": [1,2], "width": '11%'},
            //{"targets": [0], "width": '3%'},
            //{"targets": [7,8], "width": '6%'},
            //{"targets": [5], "width": '8%'}
        ],

        "order": [[1,"asc"]],
        "columnDefs": [
            {"targets" : 'no-sort', "orderable": false}
        ],
        "oSearch": {"sSearch": queryParameters().search},
        "autoWidth": false,
        "buttons": [{
            "extend":    'copyHtml5',
            "text":      '<i class="fa fa-files-o"></i>',
            "titleAttr": 'Copy',
            "exportOptions": {
                "columns": [1,2,3,4,5,6,7,8]
            }
        },
        {
            "extend":    'excelHtml5',
            "text":      '<i class="fa fa-file-excel-o"></i>',
            "titleAttr": 'Excel',
            "exportOptions": {
                "columns": [1,2,3,4,5,6,7,8]
            }
        },
        {
            "extend":    'csvHtml5',
            "text":      '<i class="fa fa-file-text-o"></i>',
            "titleAttr": 'CSV',
            "exportOptions": {
                "columns": [1,2,3,4,5,6,7,8]
            }
        },
        {
                "extend":    'import',
                "text":      '<i class="glyphicon glyphicon-import"></i>',
                "titleAttr": 'Import'
        },
        {
          "extend": 'selectAll',
          "action": function( e, dt, node, config ){
            oEventTable.$('tr').addClass('selected');
            oEventTable.$('tr').addClass('success');
            var selects = oEventTable.rows('tr.selected').data();
            if (selects.length == 0){
                $("#destroy_event").addClass("disabled");
            }else{
                $("#destroy_event").removeClass("disabled");
            }

            $(".buttons-select-none").removeClass('disabled');
          }
        },
        {
          "extend": 'selectNone',
          "action": function( e, dt, node, config ){
            oEventTable.$('tr').removeClass('selected');
            oEventTable.$('tr').removeClass('success');
            var selects = oEventTable.rows('tr.selected').data();
            if( selects.length == 0){
                $("#destroy_event").addClass("disabled");
            }else{
                $("#destroy_event").removeClass("disabled");
            }
            $(".buttons-select-none").addClass('disabled');
          }

        }

        ]
    });

    $('#event_table').on( 'click', 'tr', function () {

        var d = oEventTable.row(this).data();
        if(d != undefined){
            if($(this).hasClass('selected')){
                $(this).removeClass('selected');
                $(this).removeClass('success');

            }else{
                $(this).addClass('selected');
                $(this).addClass('success');
            }
        }
        var selects = oEventTable.rows('tr.selected').data();
        if( selects.length == 0){
          $("#destroy_event").addClass("disabled");
          $(".buttons-select-none").addClass('disabled')
        }else{
          $("#destroy_event").removeClass("disabled");
          $(".buttons-select-none").removeClass('disabled');
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
            $("#mybasho_destroy").addClass("disabled");
        }
        else {
            oMybashoTable.$('tr.selected').removeClass('selected');
            oMybashoTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $("#mybasho_destroy").removeClass("disabled");
        }
    } );

    // var s = document.getElementById('event_状態コード').value;
    // if (s != '11'){
    //     $('.event_有無').hide();
    // }


    //工程選択された行を判断
    $('#koutei_table tbody').on( 'click', 'tr', function () {

        var d = oKouteiTable.row(this).data();
        $('#event_工程コード').val(d[0]);
        //$('#koutei_name').text(d[1]);
        $('.hint-koutei-refer').text(d[1])


        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
        }
        else {
            oKouteiTable.$('tr.selected').removeClass('selected');
            oKouteiTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );

    //工程選択された行を判断
    $('#shozai_table tbody').on( 'click', 'tr', function () {

        var d = oShozaiTable.row(this).data();
        $('#event_所在コード').val(d[0]);
        $('#shozai_name').text(d[1]);

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
        }
        else {
            oShozaiTable.$('tr.selected').removeClass('selected');
            oShozaiTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );


    $('#myjob_table tbody').on( 'click', 'tr', function () {

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $("#myjob_destroy").addClass("disabled");
        }
        else {
            oMyjobTable.$('tr.selected').removeClass('selected');
            oMyjobTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $("#myjob_destroy").removeClass("disabled");
        }

    } );

    $('#user_refer_sentaku_ok').click(function(){
        var d = oTable.row('tr.selected').data();
        if(d!=undefined){
            $('#jobmaster_入力社員番号').val(d[0])
            $('.hint-shain-refer').text(d[1])
        }
    })

    $('#select_user_modal_refer,#user_table tbody').on( 'dblclick', 'tr', function () {
        $(this).addClass('selected');
        $(this).addClass('success');
        var d = oTable.row('tr.selected').data();
        if(d!=undefined){
            $('#jobmaster_入力社員番号').val(d[0])
            $('.hint-shain-refer').text(d[1])
        }
        $('#select_user_modal_refer').modal('hide');
    });



    $('#user_sentaku_ok').click(function(){
        var d = oTable.row('tr.selected').data();
        if(d!=undefined){
            $('#selected_user').val(d[0]);
            $('#selected_user_name').val(d[1]);
        }
    })

    $('#select_user_modal,#user_table tbody').on( 'dblclick', 'tr', function () {
        $(this).addClass('selected');
        $(this).addClass('success');
        var d = oTable.row('tr.selected').data();
        if(d!=undefined){
            $('#selected_user').val(d[0]);
            $('#selected_user_name').val(d[1]);
        }
        $("#user_sentaku_ok").trigger('click');
    });

});


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

$(function(){
    var s = $("#event_状態コード").val();
    $('.event_帰社').hide();
    if (s == '10' || s == '11' || s == '12' || s == '13'){
        $('.event_帰社').show();
    }
    $("#destroy_event").addClass("disabled");
});
function showModal(date,hoshukeitai) {


    // if(bt_val==1) hoshukeitai=0;
    // else if(hoshukeitai=1;
    if (hoshukeitai == "1"){
        $('#bt-hoshu-1'+date).show();
        $('#bt-hoshu-0'+date).hide();
    }else{
        $('#bt-hoshu-1'+date).hide();
        $('#bt-hoshu-0'+date).show();
    }
    if (!date || !hoshukeitai) return;
    jQuery.ajax({
        url: '/events/ajax',
        data: {id: 'kintai_保守携帯回数',hoshukeitai: hoshukeitai, date_kintai: date},
        type: "POST",
        // processData: false,
        // contentType: 'application/json',

        success: function(data) {
            if(data.kintai_id != null){
                console.log("getAjax kintai_id:"+ data.kintai_id);
            }
            else{

                console.log("getAjax kintai_id:"+ data.kintai_id);
            }
        },
        failure: function() {
            console.log("kintai_保守携帯回数 keydown Unsuccessful");
        }
    });
    $('#bt-hoshu-1').show();
    $('#bt-hoshu-0').hide();
}


function updateEvent(the_event){
    jQuery.ajax({
        url: '/events/ajax',
        data: {id: 'event_drag_update',shainId: the_event.resourceId, eventId: the_event.id, event_start: the_event.start.format('YYYY/MM/DD HH:mm'), event_end: the_event.end.format('YYYY/MM/DD HH:mm') },
        type: "POST",

        success: function(data) {
                console.log("Update success");
        },
        failure: function() {
            console.log("Update unsuccessful");
        }
    })
    $('#calendar-month-view').fullCalendar('updateEvent', the_event);
    return;


}
$(function(){
    $('#current_user_button').show();
    //when click create
    $('.submit-button').click(function(e){
        var joutai = $('#event_状態コード').val();
        if( joutai == '105' || joutai == '109' || joutai == '113'){
            $('.form-group.has-error').each(function(){
              $('.help-block', $(this)).html('');
              $(this).removeClass('has-error');
            });
            var kintai_daikyu = $('#kintai_daikyu').val();
            var old_joutai = $('#old_joutai').val();
            if ((old_joutai == '')||((old_joutai != '')&&(old_joutai != joutai))) {
                if(kintai_daikyu == ''){
                    $('#event_状態コード').val("");
                    swal("振休の状態で代休相手日付を選択しなければなりません。")
                    $input = $('#event_状態コード');
                    $input.closest('.form-group').addClass('has-error').find('.help-block').text("を入力してください。");

                    e.preventDefault();
                }
            }
        }


    })

});
