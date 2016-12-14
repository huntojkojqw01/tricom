json.array!(@myjobmasters) do |myjobmaster|
  json.extract! myjobmaster, :id,:shainbango, :jobbango, :jobname, :startdate, :enddate, :userbango, :username
  json.url myjobmaster_url(myjobmaster, format: :json)
end
