json.array!(@daily_trackings) do |daily_tracking|
  json.extract! daily_tracking, :id, :campaign_id, :platform_id, :date, :views, :clicks, :spend
  json.url daily_tracking_url(daily_tracking, format: :json)
end
