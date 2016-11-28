class AddCampaignKeyToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :campaign_key, :string, :unique => true
  end
end
