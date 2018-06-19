jQuery ->
  table_id = '#yuusen_table'
  new_path = 'yuusens/new'
  edit_path = 'yuusens/id/edit'
  delete_path = '/yuusens/id'
  no_sort_columns = []
  order_columns = []
  search_params = queryParameters().search
  get_id_from_row_data = (data)->
    return data[0]
  create_datatable(
    table_id
    new_path
    edit_path
    delete_path
    no_sort_columns
    order_columns
    search_params
    get_id_from_row_data
  )
