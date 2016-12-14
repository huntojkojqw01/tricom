json.array!(@dengonkaitous) do |dengonkaitou|
  json.extract! dengonkaitou, :id, :first_name, :last_name
  json.url dengonkaitou_url(dengonkaitou, format: :json)
end
