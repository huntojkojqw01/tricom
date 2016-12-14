// init search table
$(function() {
    oTable = $('#user_table').DataTable({
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
