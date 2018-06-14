jQuery ->
  table_id = '#myjobmaster'
  new_path = 'myjobmasters/new'
  edit_path = 'myjobmasters/id/edit'
  delete_path = '/myjobmasters/id,id'
  no_sort_columns = [12, 13]
  order_columns = [[0, "asc"], [1, "asc"]]
  search_params = current_user_id
  get_id_from_row_data = (data)->
    return data[1] + ',' + data[0]
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
