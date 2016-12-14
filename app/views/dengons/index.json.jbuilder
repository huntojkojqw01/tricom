json.array!(@dengons) do |dengon|
  json.extract! dengon, :id, :first_name, :last_name
  json.url dengon_url(dengon, format: :json)
end
