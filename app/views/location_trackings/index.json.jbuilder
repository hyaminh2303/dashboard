json.array!(@location_trackings) do |location_tracking|
  json.extract! location_tracking, :id, :campaign_id, :date, :location_id, :views, :clicks
  json.url location_tracking_url(location_tracking, format: :json)
end
