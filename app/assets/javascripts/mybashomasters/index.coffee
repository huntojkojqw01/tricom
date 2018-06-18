jQuery ->
  table_id = '#mybashomaster'
  new_path = 'mybashomasters/new'
  edit_path = 'mybashomasters/id/edit'
  delete_path = '/mybashomasters/id,id'
  no_sort_columns = [8, 9]
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
