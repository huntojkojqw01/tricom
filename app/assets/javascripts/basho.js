// init search table
$(function() {
    oTable = $('#bashomaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
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
        ,"oSearch": {"sSearch": queryParameters().search}
    });

    //init shozoku modal table
    oKaishaTable = $('#kaisha-table-modal').DataTable({
        "pagingType": "full_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });

    //選択された行を判断
    $('#kaisha-table-modal tbody').on( 'click', 'tr', function () {

        var d = oKaishaTable.row(this).data();        
        //$('#bashomaster_会社コード').val(d[0]);
        //$('#kaisha-name').text(d[1]);

        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $('#kaisha_sentaku_ok').attr('disabled',true);
            $('#bashomaster_会社コード').val('');
            $('#kaisha-name').text('');           
        }
        else {
            oKaishaTable.$('tr.selected').removeClass('selected');
            oKaishaTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $('#kaisha_sentaku_ok').attr('disabled',false);
        }

    } );
    $('#clear_kaisha').on( 'click', function () {        
        $('#bashomaster_会社コード').val('');
        $('#kaisha-name').text('');
    });
    $('#kaisha_sentaku_ok').on( 'click', function () {        
        var d = oKaishaTable.row('tr.selected').data();
        $('#bashomaster_会社コード').val(d[0]);
        $('#kaisha-name').text(d[1]);
    });
    $('.refer-kaisha').click(function(){
        $('#kaisha-search-modal').modal('show');
        if ($('#bashomaster_会社コード').val() != ''){
            oKaishaTable.rows().every( function( rowIdx, tableLoop, rowLoop ) {
              data = this.data();
              if (data[0] == $('#bashomaster_会社コード').val()) {
                oKaishaTable.$('tr.selected').removeClass('selected');
                oKaishaTable.$('tr.success').removeClass('success');
                this.nodes().to$().addClass('selected');
                this.nodes().to$().addClass('success');
                }
            });
            oKaishaTable.page.jumpToData($('#bashomaster_会社コード').val(), 0);
        }                   
    });
});

//button handle
// $(function(){
//     $('.refer-kaisha').click(function(){
//         $('#kaisha-search-modal').modal('show');        
//     });

// });

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
