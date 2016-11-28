json.array!(@location_lists) do |location_list|
  json.extract! location_list, :id
  json.url location_list_url(location_list, format: :json)
end
