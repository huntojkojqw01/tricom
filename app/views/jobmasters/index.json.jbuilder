json.array!(@jobmasters) do |jobmaster|
  json.extract! jobmaster, :id, :jobbango, :jobname, :startdate, :enddate, :userbango, :username
  json.url jobmaster_url(jobmaster, format: :json)
end
