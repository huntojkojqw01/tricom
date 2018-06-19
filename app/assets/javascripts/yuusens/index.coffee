jQuery ->
  create_datatable
    table_id: '#yuusen_table'
    new_path: 'yuusens/new'
    edit_path: 'yuusens/id/edit'
    delete_path: '/yuusens/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
