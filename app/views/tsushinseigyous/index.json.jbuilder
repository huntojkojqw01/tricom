json.array!(@tsushinseigyous) do |tsushinseigyou|
  json.extract! tsushinseigyou, :id, :first_name, :last_name
  json.url tsushinseigyou_url(tsushinseigyou, format: :json)
end
