class ChangeCampaignHasAdsGroupDefault < ActiveRecord::Migration
  def up
    change_column :campaigns, :has_ads_group, :boolean, default: false, null: false
  end

  def down
    change_column :campaigns, :has_ads_group, :boolean, default: true, null: false
  end
end
