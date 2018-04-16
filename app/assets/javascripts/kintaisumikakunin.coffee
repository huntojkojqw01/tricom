jQuery ->
  oTable = $('#kintaisumikakunin').DataTable({
    "dom": "<'row'<'col-md-6'l><'col-md-6'f>><'row'<'col-md-7'B><'col-md-5'p>><'row'<'col-md-12'tr>><'row'<'col-md-12'i>>",
    "fnDrawCallback": (oSettings) ->
    "pagingType": "simple_numbers"
    ,"oLanguage":{
      "sUrl": "../../assets/resource/dataTable_"+$('#language').text()+".txt"
    }
    ,
    "columnDefs": [ {
      "targets"  : 'no-sort',
      "orderable": false
    },
    {
      "targets" : [3],
      "bSortable" : false,
      "bSearchable" :false
    }
    ],
    "order":  [[ 1, "asc" ]],
    "oSearch": {"sSearch": queryParameters().search},

    "buttons": [{
                "extend":    'copyHtml5',
                "text":      '<i class="fa fa-files-o"></i>',
                "titleAttr": 'Copy'
            },
            {
                "extend":    'excelHtml5',
                "text":      '<i class="fa fa-file-excel-o"></i>',
                "titleAttr": 'Excel'
            },
            {
                "extend":    'csvHtml5',
                "text":      '<i class="fa fa-file-text-o"></i>',
                "titleAttr": 'CSV'
            },
            {
                "extend":    'csvHtml5',
                "text":      'JOB別CSV出力',
                "titleAttr": '年月(YYYY/MM)、社員、job別の工数集計のCSVデータ出力'                
                action: ( e, dt, node, config ) ->
                  window.open('/kintais/export_csv.csv?date='+$("#search").val())
            }

            ]
  })
  now = new Date();
  current = new Date(now.getFullYear(), now.getMonth()+1, 1);

  $('.date-search').datetimepicker({
    format: 'YYYY/MM',
    viewMode: 'months',
    keyBinds: false,
    focusOnShow: false,
    maxDate: moment(current).format('YYYY/MM/DD'),
  }).on('dp.show', () ->
    $('.date-search').data("DateTimePicker").viewMode("months")
  );
  current_date=$('#search').val()
  $('#search')
    .click () ->
      $('.date-search').data("DateTimePicker").viewMode("months").toggle()
    .on 'keypress',(e) ->
      if e.keyCode==13
        return false
    .on 'blur',()->
      if $(this).val()!=""&&$(this).val()!=current_date
        window.location="/kintais/sumikakunin?date="+ $(this).val()
