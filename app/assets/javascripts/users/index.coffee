jQuery ->
  create_datatable
    table_id: '#user_table'
    new_path: 'users/new'
    edit_path: 'users/id/edit'
    delete_path: '/users/id'
    no_sort_columns: [3, 4]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]