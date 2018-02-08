/**
 * Created by cmc on 16/12/2016.
 */

var setsubiyoyaku_timeline;
$(document).ready(function() {
    var setsubi = $('#head_setsubicode').val();
    var param = '&head[setsubicode]='+setsubi;
    $.getJSON('/setsubiyoyakus?'+param, function(data) {

        setsubiyoyaku_timeline = $('#setsubiyoyaku-timeline').fullCalendar(
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
                // titleFormat: 'YYYY年MM月(DD日)',
                //weekends: false,
                viewRender: function(view, element) {
                    var date = view.title
                    date = changeTitleFormat(date);
                    $("#setsubiyoyaku-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'</h2></div>');

                },
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
                timeFormat: 'HH:mm',
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
                    console.log(event);
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
        oTable = $('.setsubiyoyaku-table').DataTable();
        oTable.draw();
        setsubiyoyaku_timeline.find('.fc-today-button,.fc-prev-button,.fc-next-button').click(function(){
            oTable = $('.setsubiyoyaku-table').DataTable();
            oTable.draw();
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

//refresh content
$(function () {
    var setsubi = $('#head_setsubicode').val();
    var param = '&head[setsubicode]='+setsubi;
    setInterval(function () {
        $.getJSON('/setsubiyoyakus?'+param, function(data) {
            setsubiyoyaku_timeline.fullCalendar('removeEvents');
            setsubiyoyaku_timeline.fullCalendar('addEventSource', data.setsubiyoyakus);
            setsubiyoyaku_timeline.fullCalendar('rerenderEvents' );
        });
    },3000);
});

//Extend dataTables search
// $.fn.dataTable.ext.search.push(
//     function( settings, data, dataIndex ) {
//         // var min  = getStartCalendarDate2( $('.fc-left').text());
//         var min  = '2016/12/18';
//         // var max  = $('#max-date').val();
//         // var createdAt = data[2] || 0; // Our date column in the table
//         var createdAt = parseDateValue2( data[0]); // Our date column in the table
//
//         if(  moment(createdAt).isSameOrAfter(min) )
//         {
//             return true;
//         }
//         return false;
//     }
// );
// //The plugin function for adding a new filtering routine
$.fn.dataTableExt.afnFiltering.push(
    function(oSettings, aData, iDataIndex){
        var dateStart = getStartCalendarDate( $('.fc-left').text());
        var dateEnd = getEndCalendarDate( $('.fc-left').text());
        // var dateStart = parseDateValue($("#dateStart").val());
        // var dateEnd = parseDateValue($("#dateEnd").val());
        // aData represents the table structure as an array of columns, so the script access the date value
        // in the first column of the table via aData[0]
        var evalDate = parseDateValue(aData[1]);
        if (evalDate >= dateStart) {
            return true;
        }
        else {
            return false;
        }
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
/**
 * 2018年01月01日 — 07日 -> 20180101
 * @return {[type]} [description]
 */
function getStartCalendarDate(dateString){
    var res = dateString.substring(0,4) + dateString.substring(5,7) + dateString.substring(8,10);
    return res;
}

/**
 * 2018年01月01日 — 07日 -> 20180101
 * 2017年11月27日 — 12月03日 -> 20171203
 * @return {[type]} [description]
 */
function getEndCalendarDate(dateString){
    var end_date = dateString.substring(14,16);
    if(dateString.length > 17){
      res = dateString.substring(0,4) + dateString.substring(14,16) + dateString.substring(17,19);;
    }else{
      res = dateString.substring(0,4) + dateString.substring(5,7) + dateString.substring(14,16);
    }
    return res;
}

/**
 * 2018年01月01日 — 07日 -> 2018/01/01
 * @return {[type]} [description]
 */
function getStartCalendarDate2(dateString){
    var res = dateString.substring(0,4) + '/' + dateString.substring(5,7) + '/' + dateString.substring(8,10);
    return res;
}

/**
 * 2016/12/26 10:00 -> 20161226
 * @param  {[type]} rawDate [description]
 * @return {[type]}         [description]
 */
function parseDateValue(rawDate) {
    var dateArray= rawDate.substring(0,10).split("/");
    var parsedDate= dateArray[0] + dateArray[1] + dateArray[2];
    return parsedDate;
}
/**
 * 2016/12/26 10:00 -> 2016/12/26
 * @param  {[type]} rawDate [description]
 * @return {[type]}         [description]
 */
function parseDateValue2(rawDate) {
    var dateArray = rawDate.substring(0,10);
    return dateArray;
}

/**
 * 2018年2月5 – 11日 -> 2018年2月5日 – 11日
 * @param inputTitleFormat
 */
function changeTitleFormat(inputTitleFormat) {
    var indx = inputTitleFormat.indexOf('–');
    if (indx > 0)
        return insert(inputTitleFormat, indx-1, '日');
    else
        return inputTitleFormat;
}

/**
 * alert(insert("foo baz", 4, "bar "));
 * @param str
 * @param index
 * @param value
 * @returns {string}
 */
function insert(str, index, value) {
    return str.substr(0, index) + value + str.substr(index);
}