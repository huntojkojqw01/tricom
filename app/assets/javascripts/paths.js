// init search table
$(function() {
    $path = "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    oTable = $('.path-table').DataTable({"pagingType": "full_numbers"
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
      })

});