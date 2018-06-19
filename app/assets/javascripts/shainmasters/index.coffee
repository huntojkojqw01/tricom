jQuery ->
  create_datatable
    table_id: '#shainmaster'
    new_path: 'shainmasters/new'
    edit_path: 'shainmasters/id/edit'
    delete_path: '/shainmasters/id'
    no_sort_columns: [10, 11]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[1]
