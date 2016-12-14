// init search table
$(function() {
    oTable = $('#joutaimaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        }
        ,"aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 9,10]},
            {
                "targets": [9,10],
                "width": '5%',
                "targets": [7],
                "width": '90px'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]
    })


});

//colorpicker
$(function(){
    $('#joutaimaster_色').colorpicker();
    $('#joutaimaster_text_color').colorpicker();

    $('#joutaimaster_色').colorpicker().on('changeColor', function(ev){
        $('#preview-backgroud').css("background-color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

    $('#joutaimaster_text_color').colorpicker().on('changeColor', function(ev){
        $('#preview-text').css("color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

//binding preview when load
    $("#preview-text").css('color', $("#joutaimaster_text_color").val());
    $('#preview-backgroud').css("background-color", $("#joutaimaster_色").val());

});

