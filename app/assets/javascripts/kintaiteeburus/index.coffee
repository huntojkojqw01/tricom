jQuery ->
  create_datatable
    table_id: '#kintaiteeburumaster'
    new_path: 'kintaiteeburus/new'
    edit_path: 'kintaiteeburus/id/edit'
    delete_path: '/kintaiteeburus/id'
    invisible_columns: [0]
    no_search_columns: [0]
    csv_export_columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
