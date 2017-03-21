/**
 * Created by cmc on 18/03/2015.
 */

//calendar init
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
                },
                eventDragStop: function(event) {
                    flag =0;
                },
                eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
                    updateEvent(event);

                },


                eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
                    updateEvent(event);
                    // $('#calendar-timeline').fullCalendar('refetchEvents');
                },
                eventMouseover: function(event, jsEvent, view) {
                    var tooltip = '<div class="tooltipevent hover-end">' +'<div>'+ event.start.format() +'</div>' +'<div>'+ event.end.format()+'</div>' +'<div>'+ event.title +'</div>' ;
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
                        }

                    },
                    {
                        labelText: '回覧',
                        field: 'kairan',
                        width: 18,
                        render: function(resources, el) {
                            el.css('background-color', '#adadad');
                        }

                    },
                    {
                        labelText: '',
                        field: 'shinki',
                        width: 10,
                        render: function(resources, el) {

                            el.html('<a href="/events/new?param=timeline&shain_id='+resources.shainid+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
                            // el.html('<a href="/events/new?shain_id='+resources.shainid+'"></a>');
                        }

                    }
                ]
                ,resources: data.shains
            }
        );
        var nowDate = new Date();
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

        });


        //$("#calendar-timeline").fullCalendar( 'getResourceById', 'kairan' ).hide();


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

    var currentDate = new Date();

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


});

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