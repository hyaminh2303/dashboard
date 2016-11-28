class AddKeywordToCampaignAdsGroups < ActiveRecord::Migration
  def change
    add_column :campaign_ads_groups, :keyword, :string, after: :name
  end
end
