/**
 * Created by cmc on 18/03/2015.
 */

//calendar init
var shain_old = '';
var start_old = '';
var end_old = '';
var calendar;
//init time title and joutai
var weekday = ["日", "月", "火", "水", "木", "金", "土"];
// readjust sizing after font load
$(window).on('load', function() {
  $('#calendar-timeline').fullCalendar('render');
});
$(document).ready(function() {
  var roru = getUrlVars()["roru"];
  var joutai = getUrlVars()["joutai"];
  if(roru != undefined && joutai != undefined){
    $('#timeline_ロールコード').val(roru);
    $('#timeline_状態コード').val(joutai);
  }
});
$(document).on("click", ".fc-next-button", function(){
  /*var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
  var calDate = new Date(moment(selectedDate).format(''));

  var currentDate = new Date();
  $('.fc-resource-area td:nth-child(7)').each(function(){
      $(this).html('<a href="/events/new?param=timeline&shain_id='+$(this).closest('tr').attr('data-resource-id')+'&start_at='+moment(selectedDate).format()+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
  });
  var minutes = currentDate.getMinutes();
  minutes = minutes > 9 ? minutes : '0' + minutes;
  var hours = currentDate.getHours();
  hours = hours > 9 ? hours : '0' + hours;
  var date = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日"+"  ("+weekday[calDate.getDay()]+")";
  if(calDate.getDate()==currentDate.getDate()&&calDate.getMonth()==currentDate.getMonth()&&calDate.getFullYear()==currentDate.getFullYear()){
      $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+' (今日)</h2></div>');
      $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
      $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
      $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
      $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();
      $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').show();
      $('#calendar-timeline .fc-resource-area').css('width',"30%");
  }else if(calDate > currentDate ){
      $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+' (予定)</h2></div>');
      // $('.fc-resource-area col:nth-child(2)').css('width',0);
      // $('.fc-resource-area col:nth-child(3)').css('width',0);
      // $('.fc-resource-area col:nth-child(4)').css('width',0);
      // $('.fc-resource-area col:nth-child(5)').css('width',0);
      $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').hide();
      $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').hide();
      $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').hide();
      $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').hide();
      $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').hide();
      $('#calendar-timeline .fc-resource-area').css('width','14%');
  }else{
      $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'</h2></div>');
      $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
      $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
      $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
      $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();
      $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').show();
      $('#calendar-timeline .fc-resource-area').css('width',"30%");
  }*/
});
//goback scroll to last day
/*
$(document).on("click", ".fc-prev-button", function(){
    set_selected_date();
});
$(document).on("click", ".fc-next-button", function(){
    set_selected_date();
});
$(document).on("click", ".fc-next10Days-button", function(){
    set_selected_date();
});
$(document).on("click", ".fc-prev10Days-button", function(){
    set_selected_date();
});
*/
function set_selected_date() {
  $.post(
    "/settings/ajax",
    {
      setting: "setting_date",
      selected_date: $('#calendar-timeline').fullCalendar('getDate').format('YYYY/MM/DD')
    }
  );
}

$(document).on("click", ".fc-prev-button", function(){

   /* var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
    var calDate = new Date(moment(selectedDate).format(''));
    $('.fc-resource-area td:nth-child(7)').each(function(){
        $(this).html('<a href="/events/new?param=timeline&shain_id='+$(this).closest('tr').attr('data-resource-id')+'&start_at='+moment(selectedDate).format()+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
    });
    var currentDate = new Date();
    var minutes = currentDate.getMinutes();
    minutes = minutes > 9 ? minutes : '0' + minutes;
    var hours = currentDate.getHours();
    hours = hours > 9 ? hours : '0' + hours;
    var date = calDate.getFullYear()+"年"+(calDate.getMonth()+1)+"月"+calDate.getDate()+"日"+"  ("+weekday[calDate.getDay()]+")";
    if(calDate.getDate()==currentDate.getDate()&&calDate.getMonth()==currentDate.getMonth()&&calDate.getFullYear()==currentDate.getFullYear()){
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+' (今日)</h2></div>');
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();
        $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').show();
        $('#calendar-timeline .fc-resource-area').css('width',"30%");
    }else if(calDate > currentDate ){
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+' (予定)</h2></div>');
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').hide();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').hide();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').hide();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').hide();
        $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').hide();
        $('#calendar-timeline .fc-resource-area').css('width',"14%");
    }else{
        $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'</h2></div>');
        $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
        $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
        $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
        $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();
        $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').show();
        $('#calendar-timeline .fc-resource-area').css('width',"30%");
    }*/

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

    $('#create_kitaku_button').click(function(){
        var time_start = moment().format('YYYY/MM/DD HH:mm');
        var time_end = moment().add('m',5).format('YYYY/MM/DD HH:mm');

        jQuery.ajax({
        url: '/events/ajax',
        data: {id: 'create_kitaku_event',time_start: time_start, time_end: time_end},
        type: "POST",

        success: function(data) {
            if (data.create_message=="OK") {
                location.reload();
            }else{
                swal("","現在、未消化のイベントが、あります。イベント訂正後、再度、帰宅を入力してください。")
            }

        },
        failure: function() {
            console.log("Update unsuccessful");
        }
    })

    })


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

$.fn.dataTable.ext.buttons.import = {
    className: 'buttons-import',
    action: function ( e, dt, node, config ) {
        $('#import-csv-modal').modal('show');
    }
};
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
                var time_format = moment(data, 'YYYY/MM/DD HH:mm').format('YYYY/MM/DD HH:mm');
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

//button next10Days and prev10Days click handle
/*
$(function(){
    $('#next10Days').click(function() {
        var moment = $('#calendar-timeline').fullCalendar('getDate').add(10, 'days');
        var dateInput = moment.format().substr(0,10);
        date = moment('2018/02/03');
        // $('#calendar-month-view').fullCalendar('gotoDate', date);
        // $('#calendar-timeline').fullCalendar('gotoDate', date);
        var duration = {days:10};
        $('#calendar-timeline').fullCalendar( 'incrementDate', duration )
    });
    $('#prev10Days').click(function() {
        var moment = $('#calendar-timeline').fullCalendar('getDate').add(-10, 'days');
        var dateInput = moment.format().substr(0,10);
        date = moment(dateInput);
        // $('#calendar-month-view').fullCalendar('gotoDate', date);
        $('#calendar-timeline').fullCalendar('gotoDate', date);
    });
});
*/

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
function create_calendar(data) {
  var flag =0;
  calendar = $('#calendar-timeline').fullCalendar(
      {
          customButtons: {
              next10Days: {
                  text: '>+10',
                  click: function() {
                      var currentDate = $('#calendar-timeline').fullCalendar('getDate');
                      var next10Days = currentDate.add(10,'days');
                      $('#calendar-timeline').fullCalendar( 'gotoDate', next10Days );
                  },
                  icon: 'right-double-arrow'
              },
              prev10Days: {
                  text: '<-10',
                  click: function() {
                      var currentDate = $('#calendar-timeline').fullCalendar('getDate');
                      var prev10Days = currentDate.add(-10,'days');
                      $('#calendar-timeline').fullCalendar( 'gotoDate', prev10Days );
                  },
                  icon: 'left-double-arrow'
              },
              // changeView: {
              //     text: 'changeView',
              //     click: function() {
              //         $('#calendar-timeline').fullCalendar('changeView', 'timelineWeek', {
              //             start: '2017-06-01',
              //             end: '2017-06-08'
              //         });
              //     },
              //     // icon: 'left-double-arrow'
              // }
          },
          header: {
              // left: 'prev,next today myCustomButton',
              // center: 'title',
              // right: 'timelineMonth, timelineWeek, timelineDay, today, prev, next'
              right:  'today prev,next, prev10Days,next10Days, timelineDay, timeline7Day'
          },
          views: {
              timeline7Day: {
                  // type: 'timeline',
                  type: 'timelineWeek',
                  // duration: { days: 7 },
                  buttonText: '週',
                  // visibleRange: function(currentDate) {
                  //     return {
                  //         // start: currentDate.clone().subtract(3, 'days'),
                  //         start: moment().zone("+0900").startOf('week').add(1, 'day'),
                  //         // end: currentDate.clone().add(3, 'days') // exclusive end, so 3
                  //         end: moment().zone("+0900").startOf('week').add(8, 'days') // exclusive end, so 3
                  //     };
                  // },
                  slotDuration: moment.duration(1, 'day'),
                  // slotLabelInterval: moment.duration(1, 'minutes'),
                  slotLabelFormat: [
                      'M/D ddd'
                  ],
                  // slotWidth: 10
                  titleFormat: 'YYYY年M月D日 dd',
                  // titleRangeSeparator: ' to '
                  timeFormat: 'HH',
              },
              timelineDay: {
                  titleFormat: 'YYYY年M月D日 [(]dd[)]'
              }
          },
          //trigger when modify render as click navigator button
          viewRender: function(view, element) {
              var date = view.title
              var now = moment().format('YYYY/MM/DD');
              var calendar_date = $('#calendar-timeline').fullCalendar('getDate').format('YYYY/MM/DD');

              if (view.name == 'timeline7Day')
                  date = view.title;
              else if (view.name == 'timelineDay'){
                  if (now == calendar_date)
                      date = date + '  (今日)';
                  else if (now < calendar_date)
                      date = date + '  (予定)'
                  else if (now > calendar_date)
                      date = date + '  (過去)'
              }
              $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'</h2></div>');

          },
          schedulerLicenseKey: 'CC-Attribution-NonCommercial-NoDerivatives',
          lang: 'ja',
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
          nowIndicator: true,
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
          defaultDate: moment($('#goto_date').val()),
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
          },

          eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
              updateEvent(event);
              // $('#calendar-timeline').fullCalendar('refetchEvents');
          },
          eventMouseover: function(event, jsEvent, view) {
            var tooltip = '<div class="tooltipevent hover-end">' +
                          '<div>'+ event.start.format("YYYY/MM/DD HH:mm") +'</div>' +
                          '<div>'+ event.end.format("YYYY/MM/DD HH:mm")+'</div>' +
                          '<div>'+ event.title +'</div>'+
                          '<div>'+ event.bashomei +'</div>';
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
          resourceColumns: [
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
                      // el.css('background-color', resources.background_color);
                      // el.css('color', resources.text_color);
                  }
              },
              {
                  labelText: '場所',
                  field: 'bashomei',
                  width: 40,
                  render: function(resources, el) {
                      el.css('background-color', '#adadad');
                      el.html('<div align="left"><span style="margin-right:10px"></span></div>');
                  }
              },
              {
                  labelText: '伝言',
                  field: 'dengon',
                  width: 18,
                  render: function(resources, el) {
                      el.css('background-color', '#adadad');

                      el.html('<div align="right">'+
                      '<span style="margin-right:10px">'+resources.dengon+'</span>'+
                      '<a href="/dengons?head%5Bshainbango%5D='+resources.id+'">'+
                      '<i class="glyphicon glyphicon-comment" aria-hidden="true" ></i></a></div>');
                  }

              },
              {
                  labelText: '回覧',
                  field: 'kairan',
                  width: 18,
                  render: function(resources, el) {
                      el.css('background-color', '#adadad');
                      if (resources.id == $('#user_login').val()) {
                          el.html('<div align="right">'+
                          '<span style="margin-right:10px">'+resources.kairan+'</span>'+
                          '<a href="/kairans?head%5Bshainbango%5D='+resources.id+'">'+
                          '<i class="glyphicon glyphicon-envelope" aria-hidden="true"></i></a></div>');
                      }
                  }

              },
              {
                  labelText: '',
                  field: 'shinki',
                  width: 10,
                  render: function(resources, el) {
                      el.html('<a><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
                      el.click(function(){
                        window.location.href = '/events/new?param=timeline&shain_id=' + resources.id + '&start_at=' + $('#calendar-timeline').fullCalendar('getDate').format("YYYY/MM/DD");
                      });
                  }

              }
          ]
          ,resources: data.shains
      }
  );
  //scroll to date
  // calendar.fullCalendar('gotoDate', moment($('#goto_date').val()));
  // var nowDate = new Date();
  //
  // var minutes = nowDate.getMinutes();
  // minutes = minutes > 9 ? minutes : '0' + minutes;
  // var hours = nowDate.getHours();
  // hours = hours > 9 ? hours : '0' + hours;
  //
  // var date = nowDate.getFullYear()+"年"+(nowDate.getMonth()+1)+"月"+nowDate.getDate()+"日"+"  ("+weekday[nowDate.getDay()]+")";
  // $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'  (今日)</h2></div>');
  calendar.find('.fc-today-button').click(function(){
      /*var currentDate = new Date();
      var date = currentDate.getFullYear()+"年"+(currentDate.getMonth()+1)+"月"+currentDate.getDate()+"日"+"  ("+weekday[currentDate.getDay()]+")";
      $("#calendar-timeline .fc-left").replaceWith('<div class= "fc-left"><h2>'+date+'  (今日)</h2></div>');
      $('.fc-resource-area col:nth-child(2),.fc-resource-area td:nth-child(2),.fc-resource-area th:nth-child(2)').show();
      $('.fc-resource-area col:nth-child(3),.fc-resource-area td:nth-child(3),.fc-resource-area th:nth-child(3)').show();
      $('.fc-resource-area col:nth-child(4),.fc-resource-area td:nth-child(4),.fc-resource-area th:nth-child(4)').show();
      $('.fc-resource-area col:nth-child(5),.fc-resource-area td:nth-child(5),.fc-resource-area th:nth-child(5)').show();
      $('.fc-resource-area col:nth-child(6),.fc-resource-area td:nth-child(6),.fc-resource-area th:nth-child(6)').show();
      $('#calendar-timeline .fc-resource-area').css('width',"30%");
      var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
      $('.fc-resource-area td:nth-child(7)').each(function(){
          $(this).html('<a href="/events/new?param=timeline&shain_id='+$(this).closest('tr').attr('data-resource-id')+'&start_at='+moment(selectedDate).format()+'" style=""><span class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>');
      });*/
  });

  calendar.find('.fc-today-button, .fc-prev-button, .fc-next-button, .fc-next10Days-button, .fc-prev10Days-button').click(function(){
    //set current date to hidden field to goback, post it to session
    set_selected_date();
  });

  calendar.find('.fc-timeline7Day-button').click(function () {
      calendar.find('.fc-next10Days-button, .fc-prev10Days-button').addClass('fc-state-disabled');
      /*var view = $('#calendar-timeline').fullCalendar('getView');
      if(view.name == 'timeline7Day'){

      }*/
  });

  calendar.find('.fc-timelineDay-button').click(function () {
      calendar.find('.fc-next10Days-button, .fc-prev10Days-button').removeClass('fc-state-disabled');
      /*var view = $('#calendar-timeline').fullCalendar('getView');
      if(view.name == 'timeline7Day'){

      }*/
  });

  //$("#calendar-timeline").fullCalendar( 'getResourceById', 'kairan' ).hide();
  //update time
  function update_joutai_timeline(){
    var time = new Date();
    $('#timeline_time').text(moment(time).format("YYYY年M月D日 (ddd) HH:mm"));
    var selectedDate = $('#calendar-timeline').fullCalendar('getDate');
    selectedDate.hour(time.getHours());
    selectedDate.minute(time.getMinutes());
    //update joutai
    var listShain = $('#calendar-timeline').fullCalendar( 'getResources');
    for (var j = 0; j < listShain.length; j++) {
      var check_exist = false;
      var listEvents = $('#calendar-timeline').fullCalendar( 'getResourceEvents', listShain[j].id);
      for (var i = 0; i < listEvents.length; i++) {
        if (moment(listEvents[i].start) <= selectedDate && selectedDate <= moment(listEvents[i].end)) {
          check_exist = true;
          $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(3) .fc-cell-content').css('color',listEvents[i].textColor).css('background-color',listEvents[i].color);
          $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(3) .fc-cell-content>span').text(listEvents[i].joutai);
          $('.fc-resource-area tr[data-resource-id="'+listEvents[i].resourceId+'"] td:nth-child(4) .fc-cell-content>div>span').text(listEvents[i].bashomei);
          break;
        }
      }
      if(!check_exist){
        $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(3) .fc-cell-content').css('color',data.default.textColor).css('background-color',data.default.color);
        $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(3) .fc-cell-content>span').text(data.default.joutai);
        $('.fc-resource-area tr[data-resource-id="'+listShain[j].id+'"] td:nth-child(4) .fc-cell-content>div>span').text('');
      }
    }
  }
  update_joutai_timeline();
  setInterval(update_joutai_timeline, 3000);    
}