class CampaignAdsGroupsGrid

  include Datagrid

  scope do
    CampaignAdsGroup
  end

  column(:name, order: false)
  column(:keyword, order: false)
  column(:description, order: false)

  column(:updated_at, order: false)

  column(:actions, :html => true) do |model|
    render :partial => 'campaign_ads_groups/actions', :locals => {:model => model}
  end
end
