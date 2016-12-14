json.array!(@keihis) do |keihi|
  json.extract! keihi, :id, :first_name
  json.url keihi_url(keihi, format: :json)
end
