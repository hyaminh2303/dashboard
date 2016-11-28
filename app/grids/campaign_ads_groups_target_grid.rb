class CampaignAdsGroupsTargetGrid

  include Datagrid

  scope do
    CampaignAdsGroup
  end

  column(:name, order: false)
  column(:keyword, order: false)
  column(:target, order: false)
  column(:start_date, order: false)
  column(:end_date, order: false)
  column(:description, order: false)
  column(:updated_at, order: false)

  column(:actions, :html => true) do |model|
    render :partial => 'campaign_ads_groups/actions', :locals => {:model => model}
  end
end
