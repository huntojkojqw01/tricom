// init search table
$(function() {
    oTable = $('#mybashomaster').DataTable({
        "pagingType": "full_numbers"
        , "oLanguage": {
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        },
        "aoColumnDefs": [
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
    oKaishaTable = $('#kaisha-table-modal').DataTable({
        "pagingType": "full_numbers"
        ,"oLanguage":{
            "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
        }
    });

    //選択された行を判断
    $('#kaisha-table-modal tbody').on( 'click', 'tr', function () {

        var d = oKaishaTable.row(this).data();
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
            $(this).removeClass('success');
            $('#kaisha_sentaku_ok').attr('disabled',true);
            $('#clear_kaisha').attr('disabled',true);
            // $('#mybashomaster_会社コード').val('');
            // $('#kaisha-name').text('');           
        }
        else {
            oKaishaTable.$('tr.selected').removeClass('selected');
            oKaishaTable.$('tr.success').removeClass('success');
            $(this).addClass('selected');
            $(this).addClass('success');
            $('#kaisha_sentaku_ok').attr('disabled',false);
            $('#clear_kaisha').attr('disabled',false);
        }

    } );
    $('#clear_kaisha').on( 'click', function () {        
        oKaishaTable.$('tr.selected').removeClass('selected');
        oKaishaTable.$('tr.success').removeClass('success');
        $('#kaisha_sentaku_ok').attr('disabled',true);
        $('#clear_kaisha').attr('disabled',true);        
    });
    $('#kaisha_sentaku_ok').on( 'click', function () {        
        var d = oKaishaTable.row('tr.selected').data();
        $('#mybashomaster_会社コード').val(d[0]);
        $('#kaisha-name').text(d[1]);
    });
    $('.refer-kaisha').click(function(){
        $('#kaisha-search-modal').modal('show');
        if ($('#mybashomaster_会社コード').val() != ''){
            oKaishaTable.rows().every( function( rowIdx, tableLoop, rowLoop ) {
              data = this.data();
              if (data[0] == $('#mybashomaster_会社コード').val()) {
                oKaishaTable.$('tr.selected').removeClass('selected');
                oKaishaTable.$('tr.success').removeClass('success');
                this.nodes().to$().addClass('selected');
                this.nodes().to$().addClass('success');
                }
            });
            oKaishaTable.page.jumpToData($('#mybashomaster_会社コード').val(), 0);
            $('#kaisha_sentaku_ok').attr('disabled',false);
            $('#clear_kaisha').attr('disabled',false);
        }                   
    });
    
});
//keydown trigger
$(function(){
    //var url_path = $(location).attr('pathname');
    $('#mybashomaster_会社コード').keydown( function(e) {
        if (e.keyCode == 9 && !e.shiftKey) {
            var kaisha_code = $('#mybashomaster_会社コード').val();
            jQuery.ajax({
                url: '/mybashomasters/ajax',
                data: {focus_field: 'mybashomaster_会社コード', kaisha_code: kaisha_code},
                type: "POST",
                // processData: false,
                // contentType: 'application/json',
                success: function(data) {
                    $('#kaisha-name').text(data.kaisha_name);
                    console.log("getAjax mybashomaster_会社コード:"+ data.kaisha_name);
                },
                failure: function() {
                    console.log("mybashomaster_会社コード keydown Unsuccessful");
                }
            });
        }
    });
});

//Add maxlength display
$(function(){
    $('input[maxlength]').maxlength();

});
