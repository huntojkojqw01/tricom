json.array!(@kairans) do |kairan|
  json.extract! kairan, :id, :hakkousha, :namelist
  json.url kairan_url(kairan, format: :json)
end
