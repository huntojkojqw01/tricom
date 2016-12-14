json.array!(@setsubi) do |setsubi|
  json.extract! setsubi, :id, :設備コード, :設備名, :備考
  json.url setsubi_url(setsubi, format: :json)
end
