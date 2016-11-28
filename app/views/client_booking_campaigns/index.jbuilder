json.campaigns do
  json.array! (@campaigns) do |campaign|
    json.id campaign.id
    json.banner_type campaign.banner_type
    json.banner_size campaign.banner_size
    json.description campaign.description
    json.no_specific_locations campaign.no_specific_locations
    json.campaign_name campaign.campaign_name
    json.advertiser_name campaign.advertiser_name
    json.ad_tag campaign.ad_tag
    json.start_date campaign.start_date
    json.end_date campaign.end_date
    json.timezone campaign.timezone
    json.campaign_category campaign.campaign_category
    json.frequency_cap campaign.frequency_cap
    json.campaign_type campaign.campaign_type
    json.target campaign.target
    json.unit_price campaign.unit_price
    json.budget campaign.budget
    json.country_code campaign.country_code
    json.time_schedule campaign.time_schedule
    json.carrier campaign.carrier
    json.wifi_or_cellular campaign.wifi_or_cellular
    json.os campaign.os
    json.app_category campaign.app_category
    json.additional campaign.additional
    json.status campaign.status
    json.banners do
      json.array!(campaign.banners) do |banner|
        json.id banner.id
        json.image_url banner.image.url
        json.name banner.name
        json.client_booking_campaign_id banner.client_booking_campaign_id
        json.landing_url banner.landing_url
      end
    end
  end
end

json.statuses do
  json.array! ClientBookingCampaign::statuses.map { |st| {label: st[0].split('_').join(' ').capitalize, key: st[0]} }
end