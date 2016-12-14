// init search table
$(function() {
    oTable = $('#bashomaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        },
        "aoColumnDefs": [
            { "bSortable": false, "aTargets": [ 6,7 ]},
            {
                "targets": [6,7],
                "width": '5%'
            }
        ],
        "columnDefs": [ {
            "targets"  : 'no-sort',
            "orderable": false
        }]
    });

    //init shozoku modal table
    oKaishaTable = $('#kaisha-table-modal').DataTable({
        "pagingType": "full_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_ja.txt"
        }
    });

    //選択された行を判断
    $('#kaisha-table-modal tbody').on( 'click', 'tr', function () {

        var d = oKaishaTable.row(this).data();
        $('#bashomaster_会社コード').val(d[0]);
        $('#kaisha-name').text(d[1]);

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');

        }
        else {
            oKaishaTable.$('tr.selected').removeClass('selected');
            oKaishaTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
        }

    } );
});

//button handle
$(function(){
    $('.refer-kaisha').click(function(){
        $('#kaisha-search-modal').modal('show');
    });

});

//keydown trigger
$(function(){
    //var url_path = $(location).attr('pathname');
    $('#bashomaster_会社コード').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var kaisha_code = $('#bashomaster_会社コード').val();
            jQuery.ajax({
                url: '/bashomasters/ajax',
                data: {focus_field: 'bashomaster_会社コード', kaisha_code: kaisha_code},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    $('#kaisha-name').text(data.kaisha_name);
                    console.log("getAjax bashomaster_会社コード:"+ data.kaisha_name);
                },
                failure: function() {
                    console.log("bashomaster_会社コード keydown Unsuccessful");
                }
            });
        }
    });
});

//Add maxlength display
$(function(){
    $('input[maxlength]').maxlength();

});
