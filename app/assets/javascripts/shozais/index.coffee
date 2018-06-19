jQuery ->
  create_datatable
    table_id: '#shozais'
    new_path: 'shozais/new'
    edit_path: 'shozais/id/edit'
    delete_path: '/shozais/id'
    no_sort_columns: [4, 5]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
