json.array!(@bunruis) do |bunrui|
  json.extract! bunrui, :id, :first_name, :last_name
  json.url bunrui_url(bunrui, format: :json)
end
