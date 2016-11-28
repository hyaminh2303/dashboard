class AddColumnsToCampaignAdsGroups < ActiveRecord::Migration
  def change
    add_column :campaign_ads_groups, :target, :integer, after: :description
    add_column :campaign_ads_groups, :start_date, :date, after: :target
    add_column :campaign_ads_groups, :end_date, :date, after: :start_date
  end
end