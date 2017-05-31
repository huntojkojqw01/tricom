/**
 * Created by cmc on 18/03/2015.
 */

//calendar init
// var check = '';
var shain_old = '';
var start_old = '';
var end_old = '';
$(document).ready(function() {


    var roru = getUrlVars()["roru"];
    var joutai = getUrlVars()["joutai"];
    // var roru = $('#timeline_ロールコード').val();
    // var joutai = $('#timeline_状態コード').val();
    var param ='';
    if(roru!=undefined&&joutai!=undefined){
        $('#timeline_ロールコード').val(roru);
        $('#timeline_状態コード').val(joutai);
         param = 'roru='+roru+'&joutai='+joutai;
    }else{
        // jQuery.ajax({
        //     url: '/events/ajax',
        //     data: {id: 'roru_getData'},
        //     type: "POST",
        //     // processData: false,
        //     // contentType: 'application/json',

        //     success: function(data) {
        //         if(data.roru != null){
        //             $('#timeline_ロールコード').val(data.roru);
        //             alert($('#timeline_ロールコード').val());
        //             $('#timeline_状態コード').val("");
        //             console.log("getAjax roru:"+ data.roru);
        //         }
        //         else{
        //             $('#timeline_ロールコード').val("");
        //             $('#timeline_状態コード').val("");
        //             console.log("getAjax roru:"+ data.roru);
        //         }
        //     },
        //     failure: function() {
        //         console.log("roru keydown Unsuccessful");
        //     }
        // });
        roru = $('#timeline_ロールコード').val();
        joutai = $('#timeline_状態コード').val();
        param = 'roru='+roru+'&joutai='+joutai;
    }
    // roru = $('#timeline_ロールコード').val();
    // joutai = $('#timeline_状態コード').val();
    // param = 'roru='+roru+'&joutai='+joutai;
    // alert($('#timeline_ロールコード').val());
    $.getJSON('/events/time_line_view?'+param, function(data) {

        var flag =0;
        var calendar = $('#calendar-timeline').fullCalendar(
            {
                schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
                //height: 1287,
                height: "auto",
                //firstHour: '06:00',
                businessHours:{
                    start: '09:00:00', // a start time (09am in this example)
                    end: '18:00:00', // an end time (6pm in this example)

                    dow: [0, 1, 2, 3, 4, 5, 6]
                    // days of week. an array of zero-based day of week integers (0=Sunday)
                    // (Monday-Freeday in this example)
                },
                firstDay: 1,
                //editable: true,
                aspectRatio: 1.5,
                resourceAreaWidth: '30%',
                slotLabelFormat: ['HH : mm'],
                scrollTime: data.setting.scrolltime,
                //slotDuration: moment.duration(0.5, 'hours'),
                //minTime: '00:00:00',
                //maxTime: '24:00:00',
                eventOverlap: false,
                defaultView: 'timelineDay',
                dragOpacity: "0.5",
                editable: true,
                events: data.events,
                eventRender: function(event, element) {
                    element.find('span.fc-title').html(data.events.title).html(element.find('span.fc-title').text());
                    if(event.bashokubun != 1 && flag==0){
                        var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
                        var calDate = moment(selectedDate).format();
                        if(event.start.isBefore(calDate) && event.end.isAfter(calDate)){
                            $('.fc-resource-area tr[data-resource-id="'+event.resourceId+'"] td:nth-child(2)').css('color','#e6e6fa');
                        }
                    }
                },
                eventDragStart: function(event) {
                    flag =1;
                    if(event.bashokubun != 1){
                        var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
                        var calDate = moment(selectedDate).format();
                        if(event.start.isBefore(calDate) && event.end.isAfter(calDate)){

                            $('.fc-resource-area tr[data-resource-id="'+event.resourceId+'"] td:nth-child(2)').css('color','rgb(51, 51, 51)');
                        }
                    };
                    shain_old = event.resourceId;
                    start_old = event.start;
                    end_old = event.end;

                },
                eventDragStop: function(event) {
                    flag =0;
                },
                eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
                    if(shain_old==event.resourceId){
                        updateEvent(event);
                    }else{
                        event.resourceId = shain_old;
                        event.start = start_old;
                        event.end = end_old;
                        revertFunc();
                    }

                    // check_drag(event);
                    // if(check == "OK"){
                    //     updateEvent(event);
                    // }else{
                    //     revertFunc();
                    // }

                },


                eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
                    updateEvent(event);
                    // $('#calendar-timeline').fullCalendar('refetchEvents');
                },
                eventMouseover: function(event, jsEvent, view) {
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
                },
                //events: '/events.json',
                //header: {
                //left:   'title',
                //center: 'prevYear,nextYear timelineDay,timelineThreeDays',
                //right:  'today prev,next'
                //},
                //views: {
                //    timelineThreeDays: {
                //        type: 'timeline',
                //        duration: { days: 3 }
                //    }
                //},
                //eventRender: function(event, element, view) {
                //    element.qtip({
                //        content: event.description
                //    });
                //},
                // resourceGroupField: 'shozoku',
                resourceColumns: [
                    //{
                    //group: true,
                    //labelText: '所属',
                    //field: 'shozoku'
                    //},
                    // {
                    //     //group: true,
                    //     labelText: '役職',
                    //     field: 'yakushoku',
                    //     width: 75,
                    //     render: function(resources, el) {
                    //         el.css('background-color', '#5bc0de');
                    //     }

                    // },
                    {
                        labelText: '社員名',
                        field: 'shain',
                        width: 44,
                        render: function(resources, el) {
                            el.css('background-color', '#67b168');
                        }

                    },
                    {
                        labelText: '内線',
                        field: 'linenum',
                        width: 20,
                        render: function(resources, el) {
                            el.css('background-color', '#adadad');
                        }
                    },
                    {
                        labelText: '状態',
                        field: 'joutai',
                        width: 40,
                        render: function(resources, el) {
                            el.css('background-color', resources.background_color);
                            el.css('color', resources.text_color);
                        }
                    },
                    {
                        labelText: '伝言',
                        field: 'dengon',
                        width: 18,
                        render: function(resources, el) {
                            el.css('background-color', '#adadad');
                            if(parseInt(resources.dengon)>0){
                                el.html('<a href="/dengons?head%5Bshainbango%5D='+resources.shainid+'" style="color: black">'+resources.dengon+'</a>');
                            }
                        }

                    },
                    {
                        labelText: '回覧',
                        field: 'kairan',
                        width: 18,
                        render: function(resources, el) {
                            el.css('background-color', '#adadad');
                            if(parseInt(resources.kairan)>0){
                                el.html('<a href="/kairans?head%5Bshainbango%5D='+resources.shainid+'" style="color: black">'+resources.kairan+'</a>');
                            }
                        }

                    },
                    {
                        labelText: '',
                        field: 'shinki',
                        width: 10,
                        render: function(resources, el) {
                            var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
                            var calDate = moment(selectedDate).format();
                            el.html('<a href="/events/new?param=timeline&shain_id='+resources.shainid+'&start_at='+calDate+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
                            // el.html('<a href="/events/new?shain_id='+resources.shainid+'"></a>');
                        }

                    }
                ]
                ,resources: data.shains
            }
        );
        var nowDate = new Date();

        var minutes = nowDate.getMinutes();
        minutes = minutes > 9 ? minutes : '0' + minutes;
        var hours = nowDate.getHours();
        hours = hours > 9 ? hours : '0' + hours;

        var date = nowDate.getFullYear()+"年"+(nowDate.getMonth()+1)+"月"+nowDate.getDate()+"日";
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');
        calendar.find('.fc-today-button').click(function(){
            var currentDate = new Date();
            var date = currentDate.getFullYear()+"年"+(currentDate.getMonth()+1)+"月"+currentDate.getDate()+"日";
            $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');
            $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
            $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
            $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
            $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();

            $('#calendar-timeline .fc-resource-area').css('width',"30%");
            var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
            $('.fc-resource-area td:nth-child(6)').each(function(){
                $(this).html('<a href="/events/new?param=timeline&shain_id='+$(this).closest('tr').attr('data-resource-id')+'&start_at='+moment(selectedDate).format()+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
            });
        });


        //$("#calendar-timeline").fullCalendar( 'getResourceById', 'kairan' ).hide();
        //init time title and joutai
        var weekday = new Array(7);
        weekday[0] =  "日";
        weekday[1] = "月";
        weekday[2] = "火";
        weekday[3] = "水";
        weekday[4] = "木";
        weekday[5] = "金";
        weekday[6] = "土";
        //update time
        var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
        var d = moment(selectedDate);
        var calDate = new Date();
        var minutes = calDate.getMinutes();
        minutes = minutes > 9 ? minutes : '0' + minutes;
        var hours = calDate.getHours();
        hours = hours > 9 ? hours : '0' + hours;

        var time = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日"+"("+weekday[calDate.getDay()]+")  "+hours+":"+minutes;
        $('#timeline_time').text(time);
        var currentTimeText = d.year()+"/"+(d.month()+1)+"/"+d.date()+"/"+hours+":"+minutes;
        var currentTime = moment(currentTimeText,'YYYY/MM/DD HH:mm');
        var shozai = $('#timeline_所在コード').val();
        //update joutai
        var listShain = $('#calendar-timeline').fullCalendar( 'getResources');
        for (var j = 0; j < listShain.length; j++) {
            if (shozai==''|| listShain[j].id != $('#user_login').val() ) {
                var check_exist = false;
                var listEvents = $('#calendar-timeline').fullCalendar( 'getResourceEvents', listShain[j].id);
                for (var i = 0; i < listEvents.length; i++) {

                    var start_diff = currentTime.diff(moment(listEvents[i].start).format('YYYY/MM/DD HH:mm'),'minutes', true);
                    var end_diff = currentTime.diff(moment(listEvents[i].end).format('YYYY/MM/DD HH:mm'),'minutes', true);
                    // alert(start_diff+"\n"+end_diff)
                    if (start_diff>=0 && end_diff<=0) {
                        check_exist = true;
                        $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(3) .fc-cell-content').css('color',listEvents[i].textColor).css('background-color',listEvents[i].color);
                        $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(3) .fc-cell-content>span').text(listEvents[i].joutai);
                    }

                }
                if(!check_exist){
                    $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(3) .fc-cell-content').css('color',data.default.textColor).css('background-color',data.default.color);
                    $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(3) .fc-cell-content>span').text(data.default.joutai);
                }
            }
        }

        setInterval(function() {
            var shozai = $('#timeline_所在コード').val();
            //update time
            var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
            var d = moment(selectedDate);
            var calDate = new Date();
            var minutes = calDate.getMinutes();
            minutes = minutes > 9 ? minutes : '0' + minutes;
            var hours = calDate.getHours();
            hours = hours > 9 ? hours : '0' + hours;

            var time = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日"+"("+weekday[calDate.getDay()]+")  "+hours+":"+minutes;
            var date = d.year()+"年"+(d.month()+1)+"月"+d.date()+"日"
            $('#timeline_time').text(time);
            var currentTimeText = d.year()+"/"+(d.month()+1)+"/"+d.date()+"/"+hours+":"+minutes;
            var currentTime = moment(currentTimeText,'YYYY/MM/DD HH:mm');
            // if(calDate.getDate()==d.date()&&calDate.getMonth()==d.month()&&calDate.getFullYear()==d.year()){
            //     $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日) '+hours+":"+minutes+'</h2></div>');
            // }

            //update joutai
            var listShain = $('#calendar-timeline').fullCalendar( 'getResources');
            for (var j = 0; j < listShain.length; j++) {
                if (shozai==''|| listShain[j].id != $('#user_login').val() ) {
                    var check_exist = false;
                    var listEvents = $('#calendar-timeline').fullCalendar( 'getResourceEvents', listShain[j].id);
                    for (var i = 0; i < listEvents.length; i++) {

                        var start_diff = currentTime.diff(moment(listEvents[i].start).format('YYYY/MM/DD HH:mm'),'minutes', true);
                        var end_diff = currentTime.diff(moment(listEvents[i].end).format('YYYY/MM/DD HH:mm'),'minutes', true);
                        // alert(start_diff+"\n"+end_diff)
                        if (start_diff>=0 && end_diff<=0) {
                            check_exist = true;
                            $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(3) .fc-cell-content').css('color',listEvents[i].textColor).css('background-color',listEvents[i].color);
                            $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(3) .fc-cell-content>span').text(listEvents[i].joutai);
                        }

                    }
                    if(!check_exist){
                        $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(3) .fc-cell-content').css('color',data.default.textColor).css('background-color',data.default.color);
                        $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(3) .fc-cell-content>span').text(data.default.joutai);
                    }
                }

            }
        }, 3000);

    });

});

// readjust sizing after font load
$(window).on('load', function() {

    $('#calendar-timeline').fullCalendar('render');
});

// $(function(){
//     var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
//     var currentDate = new Date();
//     var calDate = moment(selectedDate).format();
//     //alert(calDate);


//     if(new Date(calDate) <= currentDate.format ){
//         alert('before date'+ new Date(calDate) +"||"+ currentDate);
//     }
// });


$(document).on("click", ".fc-next-button", function(){

    var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
    var calDate = new Date(moment(selectedDate).format(''));

    var currentDate = new Date();
    $('.fc-resource-area td:nth-child(6)').each(function(){
        $(this).html('<a href="/events/new?param=timeline&shain_id='+$(this).closest('tr').attr('data-resource-id')+'&start_at='+moment(selectedDate).format()+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
    });
    var minutes = currentDate.getMinutes();
    minutes = minutes > 9 ? minutes : '0' + minutes;
    var hours = currentDate.getHours();
    hours = hours > 9 ? hours : '0' + hours;
    var date = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日";
    if(calDate.getDate()==currentDate.getDate()&&calDate.getMonth()==currentDate.getMonth()&&calDate.getFullYear()==currentDate.getFullYear()){
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();

        $('#calendar-timeline .fc-resource-area').css('width',"30%");
    }else if(calDate > currentDate ){
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(予定)</h2></div>');
        // $('.fc-resource-area col:nth-child(2)').css('width',0);
        // $('.fc-resource-area col:nth-child(3)').css('width',0);
        // $('.fc-resource-area col:nth-child(4)').css('width',0);
        // $('.fc-resource-area col:nth-child(5)').css('width',0);
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').hide();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').hide();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').hide();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').hide();

        $('#calendar-timeline .fc-resource-area').css('width','14%');
    }


});


$(document).on("click", ".fc-prev-button", function(){

    var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
    var calDate = new Date(moment(selectedDate).format(''));
    $('.fc-resource-area td:nth-child(6)').each(function(){
        $(this).html('<a href="/events/new?param=timeline&shain_id='+$(this).closest('tr').attr('data-resource-id')+'&start_at='+moment(selectedDate).format()+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
    });
    var currentDate = new Date();
    var minutes = currentDate.getMinutes();
    minutes = minutes > 9 ? minutes : '0' + minutes;
    var hours = currentDate.getHours();
    hours = hours > 9 ? hours : '0' + hours;
    var date = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日";
    if(calDate.getDate()==currentDate.getDate()&&calDate.getMonth()==currentDate.getMonth()&&calDate.getFullYear()==currentDate.getFullYear()){
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();

        $('#calendar-timeline .fc-resource-area').css('width',"30%");
    }else if(calDate > currentDate ){
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(予定)</h2></div>');
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').hide();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').hide();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').hide();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').hide();
        $('#calendar-timeline .fc-resource-area').css('width',"14%");
    }

});



$(function(){

    $('#kensaku').click(function() {
        var roru = $('#timeline_ロールコード').val();
        var joutai = $('#timeline_状態コード').val();
        if (!window.location.hash)
        {
            window.location.replace('/events/time_line_view' + '?roru='+roru+'&joutai='+joutai);
        }
        // window.open('/events/time_line_view?roru='+roru+'&joutai='+joutai);
    });
    $('#reload_button').click(function(){
        location.reload()
    })
    $('#create_kitaku_button').click(function(){
        jQuery.ajax({
        url: '/events/ajax',
        data: {id: 'create_kitaku_event'},
        type: "POST",

        success: function(data) {
                console.log("Create success");
            location.reload();
        },
        failure: function() {
            console.log("Update unsuccessful");
        }
    })

    })


});


// function check_drag(event){
//     jQuery.ajax({
//         url: '/events/ajax',
//         data: {id: 'event_drag_check', shainId: event.resourceId, eventId: event.id},
//         type: "POST",
//         async: false,
//         success: function(data) {


//             check = data.check
//         },
//         failure: function() {
//             console.log("Update unsuccessful");
//         }
//     })
// }

function updateEvent(the_event){
    the_event.url = "/events/"+the_event.id+"/edit.html?locale=ja&param=timeline&shain_id="+the_event.resourceId;
    jQuery.ajax({
        url: '/events/ajax',
        data: {id: 'event_drag_update', shainId: the_event.resourceId, eventId: the_event.id, event_start: the_event.start.format('YYYY/MM/DD HH:mm'), event_end: the_event.end.format('YYYY/MM/DD HH:mm') },
        type: "POST",

        success: function(data) {
                console.log("Update success");
        },
        failure: function() {
            console.log("Update unsuccessful");
        }
    })
    $('#calendar-timeline').fullCalendar('updateEvent', the_event);
    return;

}
// function getUrlVars() {
//     var vars = {};
//     var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
//     function(m,key,value) {
//       vars[key] = value;
//     });
//     return vars;
//   }
$(function(){
  oEventTable = $('#event_table').DataTable({
        "dom": 'lBfrtip',
        "pagingType": "full_numbers",
        "oLanguage":{"sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"},
        "aoColumnDefs": [
            {"aTargets": [1], "mRender": function (data, type, full) {
                return '<a href="/events/' + data + '/edit">詳細</a>';
                }
            },
            {"aTargets": [2,3], "mRender": function (data, type, full) {
                var time_format = moment(data, 'YYYY-MM-DD HH:mm').format('YYYY-MM-DD HH:mm');
                if (time_format !== 'Invalid date'){
                    return time_format;
                    }else return '';
                }
            },
            { "bSortable": false, "aTargets": [ 0,1 ]},
            {"targets": [ 0,1 ],"searchable": false},
            {"targets": [ 0 ],"visible": false }
            //{"targets": [1,2], "width": '11%'},
            //{"targets": [0], "width": '3%'},
            //{"targets": [7,8], "width": '6%'},
            //{"targets": [5], "width": '8%'}
        ],

        "order": [],
        "columnDefs": [
            {"targets" : 'no-sort', "orderable": false}
        ],
        "oSearch": {"sSearch": queryParameters().search},
        "autoWidth": true,
        "buttons": [{
            "extend":    'copyHtml5',
            "text":      '<i class="fa fa-files-o"></i>',
            "titleAttr": 'Copy',
            "exportOptions": {
                "columns": [2,3,4,5,6,7,8,9]
            }
        },
        {
            "extend":    'excelHtml5',
            "text":      '<i class="fa fa-file-excel-o"></i>',
            "titleAttr": 'Excel',
            "exportOptions": {
                "columns": [2,3,4,5,6,7,8,9]
            }
        },
        {
            "extend":    'csvHtml5',
            "text":      '<i class="fa fa-file-text-o"></i>',
            "titleAttr": 'CSV',
            "exportOptions": {
                "columns": [2,3,4,5,6,7,8,9]
            }
        },
        {
          "extend": 'selectAll',
          "action": function( e, dt, node, config ){
            oEventTable.$('tr').addClass('selected');
            oEventTable.$('tr').addClass('success');
            var selects = oEventTable.rows('tr.selected').data();
            if (selects.length == 0){
                $("#destroy_event").attr("disabled", true);
            }else{
                $("#destroy_event").attr("disabled", false);
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
                $("#destroy_event").attr("disabled", true);
            }else{
                $("#destroy_event").attr("disabled", false);
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
          $("#destroy_event").attr("disabled", true);
          $(".buttons-select-none").addClass('disabled')
        }else{
          $("#destroy_event").attr("disabled", false);
          $(".buttons-select-none").removeClass('disabled');
        }
    });
    $("#destroy_event").attr("disabled", true);
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

                $("#destroy_event").attr("disabled", true);
            }, function(dismiss) {
                if (dismiss === 'cancel') {

                    var selects = oEventTable.rows('tr.selected').data();
                    if( selects.length == 0)
                      $("#destroy_event").attr("disabled", true);
                    else
                      $("#destroy_event").attr("disabled", false);
                }
            });
        }
    });
    $('#export_event').click(function(){
        location.href='/events/export_csv.csv?locale=ja';
     });
});
