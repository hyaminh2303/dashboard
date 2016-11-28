p 'sddsfsdfsdfsdsf========'
p @locations
json.array!(@locations) do |location|
  json.location_id location.data['Location']['LocationId']
  json.location_type location.data['Location']['LocationType']
  json.display_position do
    json.latitude location.data['Location']['DisplayPosition']['Latitude']
    json.longitude location.data['Location']['DisplayPosition']['Longitude']
  end
end

# {"Relevance"=>1.0, "MatchLevel"=>"city", "MatchQuality"=>{"City"=>1.0}, "Location"=>{"LocationId"=>"NT_kba2IblZBnJGLTC0ql-Q7B", "LocationType"=>"point", "DisplayPosition"=>{"Latitude"=>10.77825, "Longitude"=>106.70325}, "NavigationPosition"=>[{"Latitude"=>10.77825, "Longitude"=>106.70325}], "MapView"=>{"TopLeft"=>{"Latitude"=>10.861, "Longitude"=>106.55833}, "BottomRight"=>{"Latitude"=>10.69253, "Longitude"=>106.77527}}, "Address"=>{"Label"=>"Thành Phố Hồ Chí Minh, Việt Nam", "Country"=>"VNM", "County"=>"Thành Phố Hồ Chí Minh", "City"=>"Thành Phố Hồ Chí Minh", "AdditionalData"=>[{"value"=>"Việt Nam", "key"=>"CountryName"}, {"value"=>"Thành Phố Hồ Chí Minh", "key"=>"CountyName"}]}}}