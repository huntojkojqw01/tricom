json.array!(@jpt_holiday_msts) do |jpt_holiday_mst|
  json.extract! jpt_holiday_mst, :id, :event_date, :date,, :title, :string,, :description, :text
  json.url jpt_holiday_mst_url(jpt_holiday_mst, format: :json)
end
