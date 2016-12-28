/**
 * Created by cmc on 16/12/2016.
 */


$(document).ready(function() {
    var setsubi = $('#head_setsubicode').val();
    param = '&head[setsubicode]='+setsubi;
    $.getJSON('/setsubiyoyakus?'+param, function(data) {

        var setsubiyoyaku_timeline = $('#setsubiyoyaku-timeline').fullCalendar(
            {
                schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
                height: 600,
                //height: "auto",
                //firstHour: '06:00',
                businessHours:{
                    start: '09:00:00', // a start time (09am in this example)
                    end: '18:00:00', // an end time (6pm in this example)

                    dow: [0, 1, 2, 3, 4, 5, 6]
                    // days of week. an array of zero-based day of week integers (0=Sunday)
                    // (Monday-Freeday in this example)
                },
                header: {
                    left:   'title',
                    right:  'today,prev,next'
                },
                aspectRatio: 1.5,
                resourceAreaWidth: '15%',
                slotLabelFormat: ['HH : mm'],

                //slotDuration: moment.duration(0.5, 'hours'),
                //minTime: '00:00:00',
                //maxTime: '24:00:00',

                defaultView: 'agendaWeek',
                scrollTime: '09:00',
                dragOpacity: "0.5",
                editable: true,

                //events: data.setsubiyoyakus,
                events: data.setsubiyoyakus,
                eventRender: function(event, element) {


                  element.find('span.fc-title').html(data.setsubiyoyakus.title).html(element.find('span.fc-title').text());
                    // var date = event.start.getDate();
                    // alert(date);
                    // $('.fc-time-area tr[data-resource-id="_fc'+date+'"] ').find('span.fc-title').html(data.setsubiyoyakus.title).html(element.find('span.fc-title').text());
                },
                eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
                   // alert(event.title + " was dropped on " + event.start.format());
                    updateEvent(event);
                },


                eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
                    updateEvent(event);
                },
                dayRender: function(date, element, view){
                    // element.append("<button id='bt-new-"+date.format()+"' onclick='createEvent(\""+date.format()+"\"); return false;' "+
                    //                 "class='btn btn-primary' type='button'>新規</button>");
                    setsubiCode = $('#head_setsubicode').val();
                    // element.append("<button id='bt-new-"+date.format()+"' onclick='showModal(\""+date.format()+"\"); return false;' "+
                    //                 "value=1 class='btn btn-primary' type='button'>新規</button>");
                    element.append('<a href="/setsubiyoyakus/new?start_at='+date.format()+'&setsubi_code='+setsubiCode+
                        '" style="" class= "click-able"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
                            // el.html('<a href="/events/new?shain_id='+resources.shainid+'"></a>');

                }

                // resourceColumns: [
                //     {
                //         labelText: '日付',
                //         field: 'hizuke',
                //         width: 60,
                //         render: function(resources, el) {
                //             el.css('background-color', '#67b168');
                //         }
                //     }
                // ]
                // ,resources: data.hizukes
            }
        );
    //    $('#setsubiyoyaku-timeline').fullCalendar( 'renderEvent', data.setsubiyoyakus )
        // var nowDate = new Date();
        // var date = nowDate.getFullYear()+"年"+(nowDate.getMonth()+1)+"月"+nowDate.getDate()+"日";
        // $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');
        // setsubiyoyaku_timeline.find('.fc-today-button').click(function(){
        //     var currentDate = new Date();
        //     var date = currentDate.getFullYear()+"年"+(currentDate.getMonth()+1)+"月"+currentDate.getDate()+"日";
        //     $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');

        // });



    });


   // $('html, body').animate({scrollTop:$(document).height()/2});

});


function updateEvent(the_event){
    jQuery.ajax({
        url: '/setsubiyoyakus/ajax',
        data: {focus_field: 'setsubiyoyaku_update', eventId: the_event.id, event_start: the_event.start.format('YYYY/MM/DD HH:mm'), event_end: the_event.end.format('YYYY/MM/DD HH:mm') },
        type: "POST",

        success: function(data) {
                console.log("Update success");
        },
        failure: function() {
            console.log("Update unsuccessful");
        }
    })
    $('#setsubiyoyaku-timeline').fullCalendar('updateEvent', the_event);
    return;

}

function showModal(date) {
    setsubiCode = $('#head_setsubicode').val();
    window.open('/setsubiyoyakus/new?start_at='+date+'&setsubi_code='+setsubiCode,"_self");

}


// readjust sizing after font load
// $(window).on('load', function() {

//     $('#setsubiyoyaku-timeline').fullCalendar('render');
// });

// // $(function(){
// //     var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
// //     var currentDate = new Date();
// //     var calDate = moment(selectedDate).format();
// //     //alert(calDate);


// //     if(new Date(calDate) <= currentDate.format ){
// //         alert('before date'+ new Date(calDate) +"||"+ currentDate);
// //     }
// // });


// $(document).on("click", ".fc-next-button", function(){

//     var selectedDate = $('#setsubiyoyaku-timeline').fullCalendar('getDate');
//     var calDate = new Date(moment(selectedDate).format(''));

//     var currentDate = new Date();

//     var date = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日";
//     if(calDate.getDate()==currentDate.getDate()&&calDate.getMonth()==currentDate.getMonth()&&calDate.getFullYear()==currentDate.getFullYear()){
//         $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');


//     }else if(calDate > currentDate ){
//         $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(予定)</h2></div>');
//    }


// });


// $(document).on("click", ".fc-prev-button", function(){

//     var selectedDate = $('#setsubiyoyaku-timeline').fullCalendar('getDate');
//     var calDate = new Date(moment(selectedDate).format(''));

//     var currentDate = new Date();

//     var date = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日";
//     if(calDate.getDate()==currentDate.getDate()&&calDate.getMonth()==currentDate.getMonth()&&calDate.getFullYear()==currentDate.getFullYear()){
//         $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(今日)</h2></div>');


//     }else if(calDate > currentDate ){
//         $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'(予定)</h2></div>');
//     }

// });



function getDaysInMonth(month, year) {
     var date = new Date(year, month, 1);
     var days = [];
     while (date.getMonth() === month) {
        days.push(new Date(date));
        date.setDate(date.getDate() + 1);
     }
     return days;
}