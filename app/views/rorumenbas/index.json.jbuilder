json.array!(@rorumenba) do |rorumenba|
  json.extract! rorumenba, :id, :ロールコード, :社員番号, :氏名, :ロール内序列
  json.url rorumenba_url(rorumenba, format: :json)
end
