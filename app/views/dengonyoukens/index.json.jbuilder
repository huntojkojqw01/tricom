json.array!(@dengonyoukens) do |dengonyouken|
  json.extract! dengonyouken, :id, :first_name, :last_name
  json.url dengonyouken_url(dengonyouken, format: :json)
end
