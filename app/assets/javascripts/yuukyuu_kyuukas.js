$(function() {
    $('.yuukyuu_kyuuka_rireki_table').DataTable({
        "pagingType": "simple_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
        ,"aoColumnDefs": [
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
    })

});

$(function() {
    $('.datetime').datetimepicker({
        format: 'YYYY/MM',
        viewMode: 'months',
        keyBinds: false,
        focusOnShow: false
    }).on('dp.show', function(){
        $('.datetime').data("DateTimePicker").viewMode("months")
    });
    $('#yuukyuu_kyuuka_rireki_年月').click(function () {
        $('.datetime').data("DateTimePicker").viewMode("months").toggle();

    });

});



