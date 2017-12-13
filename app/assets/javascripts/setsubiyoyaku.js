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
                firstDay: 1,
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
                titleFormat: 'YYYY年M月Ddd',
                //weekends: false,
                aspectRatio: 1.5,
                resourceAreaWidth: '15%',
                slotLabelFormat: ['HH : mm'],
                nowIndicator: true,
                //slotDuration: moment.duration(0.5, 'hours'),
                //minTime: '00:00:00',
                //maxTime: '24:00:00',

                defaultView: 'agendaWeek',
                scrollTime: '09:00',
                dragOpacity: "0.5",
                editable: true,

                events: data.setsubiyoyakus,
                // eventRender: function(event, element) {
                //   element.find('.fc-title').html(data.setsubiyoyakus.title).html(element.find('.fc-title').text());
                  // element.closest('.fc-content').css("margin-bottom","100px");
                    // var date = event.start.getDate();
                    // alert(date);
                    // $('.fc-time-area tr[data-resource-id="_fc'+date+'"] ').find('span.fc-title').html(data.setsubiyoyakus.title).html(element.find('span.fc-title').text());
                // },
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
                    element.append('<div class= "click-able"><a href="/setsubiyoyakus/new?start_at='+date.format()+'&setsubi_code='+setsubiCode+
                        '" style="margin-right: 10px" class= "nomal"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>'+'<a href="/setsubiyoyakus/new?start_at='+date.format()+'&all_day=true&setsubi_code='+setsubiCode+
                        '" style="" class= "full-day"><span class="glyphicon glyphicon-time" aria-hidden="true"></span></a></div>');
                    // element.append('<a href="/setsubiyoyakus/new?start_at='+date.format()+'&all_day=true&setsubi_code='+setsubiCode+
                    //     '" style="" class= ""><span class="glyphicon glyphicon-time" aria-hidden="true"></span></a>');
                            // el.html('<a href="/events/new?shain_id='+resources.shainid+'"></a>');

                },
                eventAfterRender: function(event, element, view){

                    // var bottom = parseInt(element.closest('.fc-time-grid-event').css("bottom"),10);
                    // var top = parseInt(element.closest('.fc-time-grid-event').css("top"),10);
                    // var margin = (-(top + bottom)/2).toString()+"px";
                    var height = parseInt(element.closest('.fc-time-grid-event').css("height"),10);
                    var contentHeight = parseInt(element.find('.fc-content').css("height"),10);
                    var margin = ((height - contentHeight)/2).toString()+"px";
                    element.find('.fc-content').css("margin-top",margin);

                },
                eventMouseover: function(event, jsEvent, view) {
                    var tooltip = '<div class="tooltipevent hover-end">';
                    tooltip += '<div>'+ event.start.format("YYYY/MM/DD HH:mm")+'</div>'; 
                    tooltip += '<div>'+ event.end.format("YYYY/MM/DD HH:mm") +'</div>'; 
                    tooltip += '<div>'+ event.yoken +'</div>';
                    tooltip += '<div>'+ event.shain +'</div>';
                    tooltip += '<div>'+ event.description +'</div>';
                    tooltip += '</div>'
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
        setsubiyoyaku_timeline.fullCalendar('gotoDate', new Date($('#selected_date').val()));
        setsubiyoyaku_timeline.find('.fc-prev-button,.fc-next-button').click(function(){
            $.post(
                "/settings/ajax",
                {setting: "setting_date", selected_date: new Date($('#setsubiyoyaku-timeline').fullCalendar('getDate'))}
            );               
        });
    });
    
    //Add tooltip
    $(document).on('mouseover','.nomal',function(e){
        var tooltip = '<div class="tooltipevent hover-end"><div>普通時間</div></div>'
        $("body").append(tooltip);
        $(this).mouseover(function(e) {
            $(this).css('z-index', 10000);
            $('.tooltipevent').fadeIn('500');
            $('.tooltipevent').fadeTo('10', 1.9);
        }).mousemove(function(e) {
            $('.tooltipevent').css('top', e.pageY + 10);
            $('.tooltipevent').css('left', e.pageX + 20);
        });
    });
    $(document).on('mouseout','.nomal',function(e){
        $(this).css('z-index', 8);
        $('.tooltipevent').remove();

    });

    //Add tooltip
    $(document).on('mouseover','.full-day',function(e){
        var tooltip = '<div class="tooltipevent hover-end"><div>終日時間</div></div>'
        $("body").append(tooltip);
        $(this).mouseover(function(e) {
            $(this).css('z-index', 10000);
            $('.tooltipevent').fadeIn('500');
            $('.tooltipevent').fadeTo('10', 1.9);
        }).mousemove(function(e) {
            $('.tooltipevent').css('top', e.pageY + 10);
            $('.tooltipevent').css('left', e.pageX + 20);
        });
    });
    $(document).on('mouseout','.full-day',function(e){
        $(this).css('z-index', 8);
        $('.tooltipevent').remove();

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


function getDaysInMonth(month, year) {
     var date = new Date(year, month, 1);
     var days = [];
     while (date.getMonth() === month) {
        days.push(new Date(date));
        date.setDate(date.getDate() + 1);
     }
     return days;
}