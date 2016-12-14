json.array!(@yuusens) do |yuusen|
  json.extract! yuusen, :id, :first_name, :last_name
  json.url yuusen_url(yuusen, format: :json)
end
