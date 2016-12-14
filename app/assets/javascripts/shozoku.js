// init search table
$(function() {
    oTable = $('#shozokumaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        },
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 2,3 ]},
            {
                "targets": [2,3],
                "width": '5%'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]

    });
});