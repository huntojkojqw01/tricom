// init search table
$(function() {
    oTable = $('#shozais').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_ja.txt"
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

//colorpicker
$(function(){
    $('#shozai_background_color').colorpicker();
    $('#shozai_text_color').colorpicker();

    $('#shozai_background_color').colorpicker().on('changeColor', function(ev){
        $('#preview-backgroud').css("background-color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

    $('#shozai_text_color').colorpicker().on('changeColor', function(ev){
        $('#preview-text').css("color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

//binding preview when load
    $("#preview-text").css('color', $("#shozai_text_color").val());
    $('#preview-backgroud').css("background-color", $("#shozai_background_color").val());

});