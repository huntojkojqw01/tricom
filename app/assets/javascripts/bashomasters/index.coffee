jQuery ->
  create_datatable
    table_id: '#bashomaster'
    new_path: 'bashomasters/new'
    edit_path: 'bashomasters/id/edit'
    delete_path: '/bashomasters/id'
    no_sort_columns: [6, 7]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
