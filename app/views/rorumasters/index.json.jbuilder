json.array!(@rorumaster) do |rorumaster|
  json.extract! rorumaster, :id, :ロールコード, :ロール名, :序列
  json.url rorumaster_url(rorumaster, format: :json)
end
