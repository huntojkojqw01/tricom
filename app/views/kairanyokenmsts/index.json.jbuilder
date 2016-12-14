json.array!(@kairanyokenmsts) do |kairanyokenmst|
  json.extract! kairanyokenmst, :id, :first_name, :last_name
  json.url kairanyokenmst_url(kairanyokenmst, format: :json)
end
