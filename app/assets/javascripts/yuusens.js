
$(function() {
    $('.yuusen-table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
        ,"aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 3,4 ]},
            {
                "targets": [3,4],
                "width": '5%'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]
    })

});

//colorpicker
$(function() {
    $('#yuusen_色').colorpicker();

    $('#yuusen_色').colorpicker().on('changeColor', function(ev){
        $('#preview-backgroud').css("background-color", ev.color.toHex());
        $(this).val(ev.color.toHex());
    });

//binding preview when load
    $('#preview-backgroud').css("background-color", $("#yuusen_色").val());

});
