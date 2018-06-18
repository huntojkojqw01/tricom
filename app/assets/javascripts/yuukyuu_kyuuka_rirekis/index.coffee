jQuery ->
  table_id = '#yuukyuu_kyuuka_rireki_table'
  new_path = 'yuukyuu_kyuuka_rirekis/new'
  edit_path = 'yuukyuu_kyuuka_rirekis/id/edit'
  delete_path = '/yuukyuu_kyuuka_rirekis/id,id'
  no_sort_columns = [4, 5]
  order_columns = []
  search_params = queryParameters().search
  get_id_from_row_data = (data)->
    return (data[0] + ',' + data[1]).replace('/', '-')
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
