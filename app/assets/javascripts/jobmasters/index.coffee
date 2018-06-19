jQuery ->
  create_datatable
    table_id: '#jobmaster'
    new_path: 'jobmasters/new'
    edit_path: 'jobmasters/id/edit'
    delete_path: '/jobmasters/id'
    no_sort_columns: [10, 11]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
