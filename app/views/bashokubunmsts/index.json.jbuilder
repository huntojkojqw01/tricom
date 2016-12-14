json.array!(@bashokubunmsts) do |bashokubunmst|
  json.extract! bashokubunmst, :id, :first_name, :last_name
  json.url bashokubunmst_url(bashokubunmst, format: :json)
end
