json.array!(@ekis) do |eki|
  json.extract! eki, :id, :first_name, :last_name
  json.url eki_url(eki, format: :json)
end
