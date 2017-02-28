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


// require turbolinks

//= require moment
//= require moment/ja

//= require fullcalendar.min
//= require scheduler.min
// require fullcalendar/gcal
//= require gcal

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

//= require custom

// require user

//= require jquery.purr
//= require best_in_place
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require sweetalert2

// require_tree .

$(document).on('ready', function() {
  setTimeout(function() {
    $('.alert').fadeOut('normal');
  }, 6000);
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
});
$(function(){
  $("#search_icon").click(function(){
    location.href = "/main/search?search="+$("#search_field").val()
  });
  $('#search_field').keydown( function(e) {
    if (e.keyCode == 13) {
      location.href = "/main/search?search="+$("#search_field").val()
    }
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