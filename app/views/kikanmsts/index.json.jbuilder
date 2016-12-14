json.array!(@kikanmsts) do |kikanmst|
  json.extract! kikanmst, :id, :first_name, :last_name
  json.url kikanmst_url(kikanmst, format: :json)
end
