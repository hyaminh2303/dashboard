class CampaignService
  class << self
    def generate(request_campaign)
      campaign_params = {
        name: request_campaign.campaign_name,
        country_code: request_campaign.country_code.try(:upcase),
        advertiser_name: request_campaign.advertiser_name,
        expire_at: request_campaign.end_date,
        active_at: request_campaign.start_date,
        campaign_type: request_campaign.campaign_type.try(:upcase).try(:to_sym),
        unit_price: request_campaign.unit_price,
        category_id: request_campaign.campaign_category.to_i
      }.tap { |hash|
        hash[:target_click] = request_campaign.target if request_campaign.campaign_type == 'cpc'
        hash[:target_impression] = request_campaign.target if request_campaign.campaign_type == 'cpm'
      }
      Campaign.new(campaign_params)
    end
  end
end