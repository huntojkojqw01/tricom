json.array!(@kaishamasters) do |kaishamaster|
  json.extract! kaishamaster, :id, :name, :code, :note
  json.url kaishamaster_url(kaishamaster, format: :json)
end
