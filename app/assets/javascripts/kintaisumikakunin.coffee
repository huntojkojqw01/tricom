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
            }

            ]
  })
  $('.best_in_place').best_in_place()
  now = new Date();
  current = new Date(now.getFullYear(), now.getMonth()+1, 1);

  $('.date-search').datetimepicker({
    format: 'YYYY-MM',
    viewMode: 'months',
    keyBinds: false,
    focusOnShow: false,
    maxDate: moment(current).format('YYYY/MM/DD'),
  }).on('dp.show', () ->
    $('.date-search').data("DateTimePicker").viewMode("months")    
  );
  $('#search').click () ->
    $('.date-search').data("DateTimePicker").viewMode("months").toggle()
  $('#search').on 'keypress',(e) ->    
    if e.keyCode==13      
      return false  
  $('#search_btn').click ()->
    oTable.columns(2).search($('#search').val()).draw()
  $(document).on 'ready',()->
    oTable.columns(2).search($('#search').val()).draw()