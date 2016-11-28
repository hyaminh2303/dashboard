class AddTargetPerAdgroupToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :target_per_ad_group, :boolean, default: false, after: :has_ads_group
  end
end
