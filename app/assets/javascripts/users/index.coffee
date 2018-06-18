jQuery ->
  table_id = '#user_table'
  new_path = 'users/new'
  edit_path = 'users/id/edit'
  delete_path = '/users/id'
  no_sort_columns = [3, 4]
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
