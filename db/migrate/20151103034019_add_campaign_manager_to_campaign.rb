class AddCampaignManagerToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :campaign_manager, :string if !column_exists?(:campaigns, :campaign_manager)
  end
end
