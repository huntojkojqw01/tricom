jQuery ->
  table_id = '#shainmaster'
  new_path = 'shainmasters/new'
  edit_path = 'shainmasters/id/edit'
  delete_path = '/shainmasters/id'
  no_sort_columns = [10, 11]
  order_columns = []
  search_params = queryParameters().search
  get_id_from_row_data = (data)->
    return data[1]
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
