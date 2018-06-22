jQuery ->
  create_datatable
    table_id: '#shoninshamaster'
    new_path: 'shoninshamsts/new'
    edit_path: 'shoninshamsts/id/edit'
    delete_path: '/shoninshamsts/id'
    invisible_columns: [0]
    no_search_columns: [0]
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
