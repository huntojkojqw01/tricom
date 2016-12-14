// init search table
$(function() {
    oTable = $('#shainmaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        }
        ,"aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 8,9 ]},
            {
                "targets": [8,9],
                "width": '5%'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]

    });

    //init shozoku modal table
    oShozokuTable = $('#shozoku_search_table').DataTable({
        "pagingType": "full_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        }
    });

    //選択された行を判断
    $('#shozoku_search_table tbody').on( 'click', 'tr', function () {

        var d = oShozokuTable.row(this).data();
        $('#shainmaster_所属コード').val(d[0]);
        $('#shozoku_name').text(d[1]);

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
        }
        else {
            oShozokuTable.$('tr.selected').removeClass('selected');
            oShozokuTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );    
    
    //init yakushoku modal table
    oYakushokuTable = $('#yakushoku_search_table').DataTable({
        "pagingType": "full_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        }
    });

    //選択された行を判断
    $('#yakushoku_search_table tbody').on( 'click', 'tr', function () {

        var d = oYakushokuTable.row(this).data();
        $('#shainmaster_役職コード').val(d[0]);
        $('#yakushoku_name').text(d[1]);

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
        }
        else {
            oYakushokuTable.$('tr.selected').removeClass('selected');
            oYakushokuTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );

});

//button handle
$(function(){
    $('#shozoku_search').click(function(){
        $('#select_shozoku_modal').modal('show');
    });
    $('#yakushoku_search').click(function(){
        $('#select_yakushoku_modal').modal('show');
    });

});

