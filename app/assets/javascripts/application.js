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
} );
$(document).ready(function() {
  $path = "../../assets/resource/dataTable_"+$('#language').text()+".txt"
  $('#kintai_table').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": $path
        },
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 4,5 ]},
            {
                "targets": [4,5],
                "width": '5%'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]
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
