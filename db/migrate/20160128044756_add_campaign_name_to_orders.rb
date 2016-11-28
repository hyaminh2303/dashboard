class AddCampaignNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :campaign_name, :string
  end
end
