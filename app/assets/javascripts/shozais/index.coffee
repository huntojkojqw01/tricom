jQuery ->
  table_id = '#shozais'
  new_path = 'shozais/new'
  edit_path = 'shozais/id/edit'
  delete_path = '/shozais/id'
  no_sort_columns = [4, 5]
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
