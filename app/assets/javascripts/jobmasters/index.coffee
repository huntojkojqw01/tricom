jQuery ->
  table_id = '#jobmaster'
  new_path = 'jobmasters/new'
  edit_path = 'jobmasters/id/edit'
  delete_path = '/jobmasters/id'
  no_sort_columns = [10, 11]
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
