class CampaignSummary < Campaign
  scope :monthly, ->{ monthly_campaign.joins(:agency, :daily_trackings).select("#{Campaign.table_name}.*, #{Agency.table_name}.name as agency_name, SUM(views) as views, sum(clicks) as clicks, sum(spend) as spend").group(:campaign_id) }
end