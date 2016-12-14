json.array!(@shoninshamsts) do |shoninshamst|
  json.extract! shoninshamst, :id, :first_name, :last_name
  json.url shoninshamst_url(shoninshamst, format: :json)
end
