json.array!(@kouteimasters) do |kouteimaster|
  json.extract! kouteimaster, :id, :kouteicode, :kouteiname
  json.url kouteimaster_url(kouteimaster, format: :json)
end
