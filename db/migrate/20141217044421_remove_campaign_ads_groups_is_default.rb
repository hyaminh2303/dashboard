class RemoveCampaignAdsGroupsIsDefault < ActiveRecord::Migration
  def up
    change_table :campaign_ads_groups do |t|
      t.remove :is_default
    end
  end

  def down
    change_table :campaign_ads_groups do |t|
      t.boolean :is_default, default: false, null: false
    end
  end
end
