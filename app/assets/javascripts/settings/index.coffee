jQuery ->
  create_datatable
    table_id: '#settingmaster'
    new_path: 'settings/new'
    edit_path: 'settings/id/edit'
    delete_path: '/settings/id'
    search_params: queryParameters().search
    get_id_from_row_data: (data)->
      return data[0]
