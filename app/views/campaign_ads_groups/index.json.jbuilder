json.array!(@campaign_ads_groups) do |campaign_ads_group|
  json.extract! campaign_ads_group, :id
  json.url campaign_ads_group_url(campaign_ads_group, format: :json)
end
