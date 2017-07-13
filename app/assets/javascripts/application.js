// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs

//= require chat
//= require private_pub
//= require main

// require turbolinks

//= require moment
//= require moment/ja

//= require fullcalendar.min
//= require scheduler.min
// require fullcalendar/gcal
//= require gcal
//= require dropzone.min
//= require dataTables/jquery.dataTables.min
//= require dataTables/dataTables.bootstrap.min
//= require dataTables/dataTables.fixedColumns.min
//= require dataTables/dataTables.select.min
//= require dataTables/dataTables.buttons.min
//= require dataTables/buttons.html5.min
//= require dataTables/jszip.min
//= require dataTables/pdfmake.min
//= require dataTables/vfs_fonts
// require dataTables/jquery-1.12.4
//= require bootstrap-datetimepicker
//= require bootstrap-colorpicker
//= require dataTables/fnFindCellRowIndexes
//= require dataTables/page.jumpToData()

//= require custom

// require user

//= require jquery.purr
//= require best_in_place
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require sweetalert2
//= require html.sortable
// require_tree .

$(document).on('ready', function() {
  setTimeout(function() {
    $('.alert').fadeOut('normal');
  }, 6000);

  // setInterval(function() {
  //   jQuery.ajax({
  //     url: '/main.json',
  //     dataType: "JSON",
  //     method: "GET",
  //     success: function(data) {
  //       // if(data.notification.kairanCount > 0){
  //       //   if($('.glyphicon-envelope').hasClass('text-red') == false){
  //       //     $('.glyphicon-envelope').addClass('text-red');
  //       //     $('.kairan-count').addClass('text-red');
  //       //   }
  //       //   $(".kairan-count").text(data.notification.kairanCount)
  //       //   $(".kairan-count-main").text(data.notification.kairanCount)
  //       //   $(".kairan-item").css("display","")
  //       //   var items = ''
  //       //   for (var i = 0; i < data.notification.kairanCount ; i++) {
  //       //     items = items + data.my_kairans[i].item
  //       //   }
  //       //   $(".kairan-item").html(items)
  //       // }else{
  //       //   if($('.glyphicon-envelope').hasClass('text-red')){
  //       //     $('.glyphicon-envelope').removeClass('text-red');
  //       //     $('.kairan-count').removeClass('text-red');
  //       //   }
  //       //   $(".kairan-item").css("display","none")
  //       //   $(".kairan-count").text('')
  //       //   $(".kairan-count-main").text('')
  //       //   $(".kairan-item").html('')
  //       // }
  //       // if(data.notification.dengonCount > 0){
  //       //    if($('.glyphicon-comment').hasClass('text-red') == false){
  //       //     $('.glyphicon-comment').addClass('text-red');
  //       //     $('.dengon-count').addClass('text-red');
  //       //   }
  //       //   $(".dengon-count").text(data.notification.dengonCount)
  //       //   $(".dengon-count-main").text(data.notification.dengonCount)
  //       //   $(".dengon-item").css("display","")
  //       //   var items = ''
  //       //   for (var i = 0; i < data.notification.dengonCount ; i++) {
  //       //     items = items + data.my_dengons[i].item
  //       //   }
  //       //   $(".dengon-item").html(items)
  //       // }else{
  //       //   if($('.glyphicon-comment').hasClass('text-red')){
  //       //     $('.glyphicon-comment').removeClass('text-red');
  //       //     $('.dengon-count').removeClass('text-red');
  //       //   }
  //       //   $(".dengon-item").css("display","none")
  //       //   $(".dengon-count").text('')
  //       //   $(".dengon-count-main").text('')
  //       //   $(".dengon-item").html('')
  //       // }
  //       if(data.notification.totalCount > 0){
  //         if($('.glyphicon-bell').hasClass('text-red') == false){
  //           $('.glyphicon-bell').addClass('text-red');
  //           $('.message-count').addClass('text-red');
  //         }
  //         $(".message-count").text(data.notification.totalCount)
  //         $(".message-item").css("display","")
  //         var items = ''
  //         for (var i = 0; i < data.notification.messageCount ; i++) {
  //           items = items + data.my_messages[i].item
  //         }
  //         if (data.notification.messageCount > 0 && data.notification.kairanCount){
  //           items = items + "<legend class='menu'></legend>"
  //         }
  //         for (var i = 0; i < data.notification.kairanCount ; i++) {
  //           items = items + data.my_kairans[i].item
  //         }
  //         if ((data.notification.messageCount > 0 || data.notification.kairanCount > 0) && data.notification.dengonCount >0){
  //           items = items + "<legend class='menu'></legend>"
  //         }
  //         for (var i = 0; i < data.notification.dengonCount ; i++) {
  //           items = items + data.my_dengons[i].item
  //         }

  //         $(".message-item").html(items)
  //       }else{
  //         if($('.glyphicon-bell').hasClass('text-red')){
  //           $('.glyphicon-bell').removeClass('text-red');
  //           $('.message-count').removeClass('text-red');
  //         }
  //         $(".message-item").css("display","none")
  //         $(".message-count").text('')
  //         $(".kairan-item").html('')
  //       }

  //       // alert(data.notification.kairanCount)
  //     },
  //     failure: function() {
  //         console.log("Unsuccessful");
  //     },
  //     global: false
  // });

  // }, 6000);
  $(".link-top").hide();
  if($(".link-top").length > 0){
    $(window).scroll(function () {
      var e = $(window).scrollTop();
      if (e > 300) {
        $(".link-top").show()
      } else {
        $(".link-top").hide()
      }
    });
    $(".link-top").click(function () {
      $('body,html').animate({
        scrollTop: 0
      })
    })
  }
});

$(window).on('load', function() {
  var title = $(document).find("title").text();

  jQuery.ajax({
      url: '/main/ajax',
      data: {id: 'check_title',title: title},
      type: "POST",
      success: function(data) {
        console.log("Successful");
        // $('#search_field').autocomplete({
        //   source: function( request, response ) {
        //       response(data.source);
        //   }
        // }).focus(function() {
        //   $('#search_field').autocomplete('search'," ")
        // });
          // if (data.include == "true"){
          //   check_exit = false;
          //   for (var i = 0; i < number_url; i++) {
          //     if($.cookie('previousUrl'+i) == title){
          //       check_exit = true;
          //       break;
          //     }
          //   }
          //   if(check_exit == false){
          //     alert("set:"+index_url+";"+title);
          //     $.cookie('previousUrl'+index_url,null);
          //     $.cookie('previousUrl'+index_url,title);
          //     if(number_url<5){
          //       number_url = number_url+1;
          //       $.cookie('number_url',null);
          //       $.cookie('number_url',number_url);
          //     }
          //     if(index_url<5){
          //       index_url = index_url+1;
          //       $.cookie('index_url',null);
          //       $.cookie('index_url',index_url);
          //     }else{
          //       $.cookie('index_url',null);
          //       $.cookie('index_url',0);
          //     }
          //   }
          // }
      },
      failure: function() {
          console.log("Unsuccessful");
      }
  });
  // var index_url = parseInt($.cookie('index_url'));
  // var number_url = parseInt($.cookie('number_url'));
  // alert("index="+index_url+";"+"number="+number_url);
  // for (var i = 0; i < 5; i++) {
  //   alert($.cookie('previousUrl'+i));
  // }
});


$(document).ready(function() {
  $path = "../../assets/resource/dataTable_"+$('#language').text()+".txt"
  $('#export_table').DataTable({"pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": $path
        }});
  $('#kintai_table').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": $path
        }
    });
  $('#keihihead_table').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": $path
        }
    });

});
//get param from Url
//var roru = getUrlVars()["roru"];

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
    function(m,key,value) {
      vars[key] = value;
    });
    return vars;
  }
//ex. queryParameters().search
function queryParameters () {
        var result = {};

        var uri_dec = decodeURIComponent(window.location.search);
        var params = uri_dec.split(/\?|\&/);

        params.forEach( function(it) {
            if (it) {
                var param = it.split("=");
                result[param[0]] = param[1];
            }
        });
        return result;
    }
//display thumb preview of avatar in Edit User
function readURL(input) {

    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#thumb').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$(document).ready(function() {
    $("#user_avatar").change(function(){
        readURL(this);
    });
    $('.loader').hide();
    $(document).ajaxStart(function(){
        $('.loader').show();
    })
    $(document).ajaxStop(function(){
        setTimeout(function()
            {
              $('.loader').hide();
            },
            1000
        );
    });
});
jQuery(window).load(function () {
    setTimeout(function()
            {
              $('.loader').hide();
            },
            1000
        );

});
$(document).on('click', function (e) {
    var $menu = $('#search_field');
    var $search_select = $('#search_select');
    var search_value = $('#search_field').val();

    // If element is opened and click target is outside it, hide it
    if ($menu.is(':visible') && !$menu.is(e.target) && !$menu.has(e.target).length&& !$search_select.is(e.target) && !$search_select.has(e.target).length&&search_value=='') {
      // $('.search-group').removeClass('col-md-6 col-xs-10 col-sm-8 col-lg-6');
      // $('.search-group').addClass('col-md-4 col-xs-8 col-sm-6 col-lg-4');
      $('.search-group-nav').attr('hidden','true');
      $('.search-group-select').removeAttr('hidden');

    }
});
$(function(){

  $("#search_icon").click(function(){
    // location.href = "/main/search?search="+$("#search_field").val()
    $('.search-group-nav').attr('hidden','true');
    $('.search-group-select').removeAttr('hidden');
  });
  // $("#search_field").click(function(){
  //   $('.search-group').removeClass('col-md-4 col-xs-8 col-sm-6 col-lg-4');
  //   $('.search-group').addClass('col-md-6 col-xs-10 col-sm-8 col-lg-6');
  // });
  $('#search_field').keydown( function(e) {
    if (e.keyCode == 13) {
      location.href = "/main/search?search="+$("#search_field").val()
    }else{
      $("#search_field").autocomplete("option", "source", function( request, response ) {
          var search = $("#search_field").val();
          return $.ajax({
            type: "GET",
            url: "/main/search.json",
            data: {search: search},
            success: function(data){
              console.log(data);
              response(data);
            }
          });
        }
      );
    }
  });
  $("#search_select").click(function(){
    $('.search-group-nav').removeAttr('hidden');
    $('.search-group-select').attr('hidden','true');
    $('#search_field').autocomplete({
      source: function( request, response ) {
        return $.ajax({
          url: '/main/ajax',
          data: {id: 'get_source'},
          type: "POST",
          success: function(data){
            console.log(data.source);
            response(data.source);
          }
        });
      }
    }).focus(function() {
      $('#search_field').autocomplete('search'," ")
    });
    $("#search_field").focus();
  });
});
//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  swal({
    title: message,
    type: 'warning',
    confirmButtonText: 'OK',
    cancelButtonText: "キャンセル",
    confirmButtonColor: '#2acbb3',
    showCancelButton: true
  }).then(function(e){
    $.rails.confirmed(link);
  });
};

// jQuery(function(){
//   return $("#search_field").autocomplete("option", "source", function( request, response ) {
//       var search = $("#search_field").val();
//       alert("test");
//       return $.ajax({
//         type: "GET",
//         url: "/main/search.json",
//         data: {search: search},
//         success: function(data){
//           console.log(data);
//           response(data);
//         }
//       });
//     }
//   );
// });
